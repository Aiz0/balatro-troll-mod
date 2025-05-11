SMODS.ConsumableType({
    key = "funny",
    primary_colour = HEX("FFFFFF"),
    secondary_colour = HEX("FC03CE"),
})

SMODS.Consumable({
    key = "six",
    set = "funny",
    config = {
        extra = {
            edition,
            suit,
            seal,
            enhancement,
        },
        max_highlighted = 2,
    },
    no_collection = true,
    use = function(self, card, area, copier)
        for i, v in pairs(G.hand.highlighted) do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    v:flip()
                    play_sound("card1", percent)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end,
            }))
        end
        for i, v in pairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.5,
                func = function()
                    v:set_edition(card.ability.extra.edition)
                    v:set_seal(card.ability.extra.seal)
                    v:set_ability(card.ability.extra.enhancement)
                    SMODS.change_base(v, card.ability.extra.suit, "6")
                    return true
                end,
            }))
        end
        for i, v in pairs(G.hand.highlighted) do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({
                trigger = "after",
                delay = 0.15,
                func = function()
                    v:flip()
                    play_sound("tarot2", percent, 0.6)
                    G.hand.highlighted[i]:juice_up(0.3, 0.3)
                    return true
                end,
            }))
        end
        G.E_MANAGER:add_event(Event({
            trigger = "after",
            func = function()
                G.hand:unhighlight_all()
                return true
            end,
        }))
    end,
    in_pool = function(self, args)
        return false
    end,
    set_sprites = function(self, card, front)
        if card.ability then
            if card.ability.enhancement then
                card:set_sprites(G.P_CENTERS[card.ability.enhancement])
            elseif card.ability.extra then
                card:set_sprites(G.P_CENTERS[card.ability.extra.enhancement])
            end
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            card:set_sprites(G.P_CENTERS[card.ability.extra.enhancement])
        end
    end,
})

return {
    key = "sixth_sense",
    config = {
        extra = 1,
    },
    calculate = function(self, card, context)
        if
            context.destroying_card
            and #context.full_hand == 1
            and context.full_hand[1]:get_id() == 6
            and G.GAME.current_round.hands_played == 0
        then
            if
                #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit
            then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = "before",
                    func = function()
                        local area = G.consumeables
                        local created_card = SMODS.create_card({
                            key = "c_folly_six",
                        })
                        local edition_rate = 2
                        local edition = poll_edition(
                            "standard_edition" .. G.GAME.round_resets.ante,
                            edition_rate,
                            true
                        )
                        local suit = pseudorandom_element(SMODS.Suits, pseudoseed("suit"))
                        created_card.ability.extra.suit = suit.key
                        SMODS.change_base(created_card, suit.key, "6")
                        created_card:set_edition(edition, true, true)
                        created_card.ability.extra.edition = edition
                        local seal = SMODS.poll_seal({ mod = 10 })
                        created_card:set_seal(seal)
                        created_card.ability.extra.seal = seal
                        local enhancement = SMODS.poll_enhancement({
                            mod = 6,
                            options = {
                                "m_bonus",
                                "m_mult",
                                "m_wild",
                                "m_glass",
                                "m_steel",
                                "m_gold",
                                "m_lucky",
                            },
                        })
                        created_card.ability.extra.enhancement = enhancement
                        created_card:set_sprites(G.P_CENTERS[enhancement])
                        area:emplace(created_card)
                        G.GAME.consumeable_buffer = 0
                        created_card:set_debuff(false)
                        return true
                    end,
                }))
            end
            return true
        end
    end,
}
