local chicken = SMODS.Joker({
    key = "chicken",
    atlas = "folly_jokers",
    pos = { x = 4, y = 3 },
    config = {
        extra = {
            sell_value_lost = 1,
            joker = folly_utils.prefix.joker .. "egg",
            odds = 4,
        },
        card_limit = 1,
    },
    loc_vars = function(self, info_queue, card)
        info_queue[#info_queue + 1] = G.P_CENTERS[card.ability.extra.joker]
        -- should not be needed since chicken will always be eternal
        --info_queue[#info_queue + 1] = { key = "eternal", set = "Other" }
        return { vars = { card.ability.card_limit, card.ability.extra.sell_value_lost } }
    end,
    in_pool = function(self, args)
        return false
    end,
    set_ability = function(self, card, initial, delay_sprites)
        card:set_eternal(true)
    end,
    calculate = function(self, card, context)
        if context.setting_blind then
            if
                SMODS.pseudorandom_probability(card, self.key, 1, card.ability.extra.odds, self.key)
            then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        SMODS.add_card({
                            key = card.ability.extra.joker,
                            edition = "e_negative",
                            stickers = { "eternal" },
                        })
                        return true
                    end,
                }))
                return {
                    message = localize("k_plus_joker"),
                    colour = G.C.BLUE,
                }
            end
        end

        if
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        then
            SMODS.scale_card(card, {
                ref_table = card.ability,
                ref_value = "extra_value",
                scalar_table = card.ability.extra,
                scalar_value = "sell_value_lost",
                operation = "-",
                message_key = "a_folly_val_down",
            })

            card:set_cost()
        end
    end,
})

return {
    key = "egg",
    config = { extra = { price = 3, odds = 4 } },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.price } }
    end,
    calculate = function(self, card, context)
        if
            context.end_of_round
            and context.game_over == false
            and context.main_eval
            and not context.blueprint
        then
            if
                SMODS.pseudorandom_probability(card, self.key, 1, card.ability.extra.odds, self.key)
            then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- first play some sound effects and juice up card
                        play_sound("tarot1")
                        card.T.r = -0.2
                        card:juice_up(0.3, 0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = "after",
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                SMODS.add_card({
                                    key = chicken.key,
                                    no_edition = true,
                                })
                                card:remove()
                                return true
                            end,
                        }))
                        return true
                    end,
                }))
                return { message = localize("k_folly_hatched") }
            else
                SMODS.scale_card(card, {
                    ref_table = card.ability,
                    ref_value = "extra_value",
                    scalar_table = card.ability.extra,
                    scalar_value = "price",
                    message = localize("k_val_up"),
                })

                card:set_cost()
                -- required otherwise it crashes
                -- it's possible this can be removed
                return {}
            end
        end
    end,
}
