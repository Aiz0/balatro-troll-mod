local use_and_sell_buttonsref = G.UIDEF.use_and_sell_buttons
function G.UIDEF.use_and_sell_buttons(card)
    local retval = use_and_sell_buttonsref(card)
    if
        card.area
        and card.area.config.type == "joker"
        and card.ability.set == "Joker"
        and card.ability.debuff_sources
        and card.ability.debuff_sources["drivers_license_expired"]
    then
        local use = {
            n = G.UIT.C,
            config = { h = 0.6, align = "cr" },
            nodes = {
                {
                    n = G.UIT.C,
                    config = {
                        ref_table = card,
                        align = "cr",
                        maxw = 1.25,
                        padding = 0.1,
                        r = 0.08,
                        minw = 1.25,
                        hover = true,
                        shadow = true,
                        colour = G.C.GOLD,
                        one_press = true,
                        button = "sell_card",
                        func = "can_renew_drivers_license",
                    },
                    nodes = {
                        {
                            n = G.UIT.C,
                            config = { align = "tm" },
                            nodes = {
                                { n = G.UIT.B, config = { w = 0.1, h = 0.6 } },
                                {
                                    n = G.UIT.C,
                                    config = { align = "tm" },
                                    nodes = {
                                        {
                                            n = G.UIT.R,
                                            config = { align = "cm", maxw = 1.25 },
                                            nodes = {
                                                {
                                                    n = G.UIT.T,
                                                    config = {
                                                        text = localize("k_folly_renew_drivers_license"),
                                                        colour = G.C.UI.TEXT_LIGHT,
                                                        scale = 0.4,
                                                        shadow = true,
                                                    },
                                                },
                                            },
                                        },
                                        {
                                            n = G.UIT.R,
                                            config = { align = "cm" },
                                            nodes = {
                                                {
                                                    n = G.UIT.T,
                                                    config = {
                                                        text = localize("$"),
                                                        colour = G.C.WHITE,
                                                        scale = 0.4,
                                                        shadow = true,
                                                    },
                                                },
                                                {
                                                    n = G.UIT.T,
                                                    config = {
                                                        ref_table = card,
                                                        ref_value = "cost",
                                                        colour = G.C.WHITE,
                                                        scale = 0.55,
                                                        shadow = true,
                                                    },
                                                },
                                            },
                                        },
                                    },
                                },
                            },
                        },
                    },
                },
            },
        }
        retval.nodes[1].nodes[2].nodes = retval.nodes[1].nodes[2].nodes or {}
        table.insert(retval.nodes[1].nodes[2].nodes, use)
    end
    return retval
end

G.FUNCS.can_renew_drivers_license = function(e)
    if
        (G.play and #G.play.cards > 0)
        or G.CONTROLLER.locked
        or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
        or e.config.ref_table.cost > G.GAME.dollars - G.GAME.bankrupt_at
    then
        e.config.colour = G.C.UI.BACKGROUND_INACTIVE
        e.config.button = nil
    else
        e.config.colour = G.C.GOLD
        e.config.button = "renew_drivers_license"
    end
end

G.FUNCS.renew_drivers_license = function(e)
    local card = e.config.ref_table
    card:renew_drivers_license()
end

function Card:renew_drivers_license()
    G.CONTROLLER.locks.selling_card = true
    stop_use()
    local area = self.area
    G.CONTROLLER:save_cardarea_focus("jokers")
    if self.children.use_button then
        self.children.use_button:remove()
        self.children.use_button = nil
    end
    SMODS.calculate_effect({ message = localize("k_folly_drivers_license_renewed") }, self)
    SMODS.debuff_card(self, false, "drivers_license_expired")
    self.ability.drivers_license_renewed = true
    self.children.center:set_sprite_pos({ x = 1, y = 0 })

    self.area:remove_from_highlighted(self)
    G.CONTROLLER.locks.selling_card = nil
    G.CONTROLLER:recall_cardarea_focus("jokers")
end

return {
    key = "drivers_license",
    atlas = "folly_jokers",
    pos = { x = 0, y = 0 },
    calculate = function(self, card, context)
        if context.joker_main and (card.ability.driver_tally or 0) >= 16 then
            if not context.blueprint then card.ability.driver_used = true end
            return {
                xmult = card.ability.extra,
            }
        end

        if
            context.end_of_round
            and context.individual
            and not context.repetition
            and card.ability.driver_used
            and not card.ability.drivers_license_renewed
        then
            SMODS.calculate_effect({ message = localize("k_folly_drivers_license_expired") }, card)
            SMODS.debuff_card(card, true, "drivers_license_expired")
        end
    end,
    set_sprites = function(self, card, front)
        if card.ability and card.ability.drivers_license_renewed then
            card.children.center.set_sprite_pos({ x = 1, y = 0 })
        end
    end,
}
