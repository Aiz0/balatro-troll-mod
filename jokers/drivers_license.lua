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
            card.ability.folly_show_button = true
        end
    end,

    set_sprites = function(self, card, front)
        if card.ability and card.ability.drivers_license_renewed then
            card.children.center:set_sprite_pos({ x = 1, y = 0 })
        end
    end,

    folly_can_use_button = function(self, card)
        return not (
            (G.play and #G.play.cards > 0)
            or G.CONTROLLER.locked
            or (G.GAME.STOP_USE and G.GAME.STOP_USE > 0)
            or card.cost > G.GAME.dollars - G.GAME.bankrupt_at
        )
    end,

    --Card:renew_drivers_license
    folly_button_use = function(self, card)
        G.CONTROLLER.locks.selling_card = true
        stop_use()
        G.CONTROLLER:save_cardarea_focus("jokers")
        if card.children.use_button then
            card.children.use_button:remove()
            card.children.use_button = nil
        end

        G.E_MANAGER:add_event(Event({
            trigger = "after",
            delay = 0.1,
            func = function()
                SMODS.calculate_effect({ message = localize("k_folly_drivers_license_renewed") }, card)
                SMODS.debuff_card(card, false, "drivers_license_expired")
                card.ability.drivers_license_renewed = true
                card.ability.folly_show_button = false
                card.children.center:set_sprite_pos({ x = 1, y = 0 })

                play_sound("card1")
                inc_career_stat("c_shop_dollars_spent", card.cost)
                if card.cost ~= 0 then ease_dollars(-card.cost) end

                card.area:remove_from_highlighted(card)
                G.CONTROLLER.locks.selling_card = nil
                G.CONTROLLER:recall_cardarea_focus("jokers")
                return true
            end,
        }))
    end,

    folly_button_nodes = function(self, card)
        return {
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
        }
    end,
}
