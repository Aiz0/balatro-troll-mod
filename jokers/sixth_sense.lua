SMODS.ConsumableType({
    key = "funny",
    primary_colour = HEX("FFFFFF"),
    secondary_colour = HEX("FC03CE"),
    loc_txt = {
        name = 'Funny :)', -- TODO figure out how to localize this shit
        collection = 'Funny :)',
        undiscovered = {
            name = 'Funny :)',
            text = { 'Funny :)' },
        },
    }
})

SMODS.Consumable({
    key = "six",
    set = "funny",
    config = {
        max_highlighted = 2,
    },
    no_collection = true,
    use = function(self, card, area, copier)
        for i, v in pairs(G.hand.highlighted) do
            local percent = 1.15 - (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
                v:flip();
                play_sound('card1', percent);
                G.hand.highlighted[i]:juice_up(0.3, 0.3);
                return true
            end }))
        end
        for i, v in pairs(G.hand.highlighted) do
            G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.5, func = function()
                v:set_edition(card.ability.edition)
                v:set_seal(card.ability.seal)
                v:set_ability(card.ability.enhancement)
                SMODS.change_base(v, card.ability.suit, '6')
                return true
            end }))
        end
        for i, v in pairs(G.hand.highlighted) do
            local percent = 0.85 + (i - 0.999) / (#G.hand.highlighted - 0.998) * 0.3
            G.E_MANAGER:add_event(Event({ trigger = 'after', delay = 0.15, func = function()
                v:flip();
                play_sound('tarot2', percent, 0.6);
                G.hand.highlighted[i]:juice_up(0.3, 0.3);
                return true
            end }))
        end
        G.E_MANAGER:add_event(Event({ trigger = 'after', func = function()
            G.hand:unhighlight_all()
            return true
        end }))
    end,
    in_pool = function(self, args)
        return false
    end,
    load = function(self, card, card_table, other_card)
        card:set_edition(card.ability.edition)
        card:set_seal(card.ability.seal)
        SMODS.change_base(card, card.ability.suit, '6')
    end,
    set_sprites = function(self, card, front)
        if card.ability then
            card:set_sprites(G.P_CENTERS[card.ability.enhancement])
        end
    end,
})

function random_suit()
    local random = pseudorandom("suit") * 4
    if random < 1 then
        return "Hearts"
    elseif random < 2 then
        return "Diamonds"
    elseif random < 3 then
        return "Clubs"
    end

    return "Spades"
end

return {
    key = "sixth_sense",
    name = "fj_sixth_sense",
    config = {
        extra = 1,
    },
    prev_state = nil,
    calculate = function(self, card, context)
        if context.destroying_card and #context.full_hand == 1 and context.full_hand[1]:get_id() == 6 and G.GAME.current_round.hands_played == 0 then
            if #G.consumeables.cards + G.GAME.consumeable_buffer < G.consumeables.config.card_limit then
                G.GAME.consumeable_buffer = G.GAME.consumeable_buffer + 1
                G.E_MANAGER:add_event(Event({
                    trigger = 'before',
                    func = function()
                        local area = G.consumeables
                        local create_card = SMODS.create_card({
                            key = 'c_folly_six'
                        })
                        local edition_rate = 2
                        local edition = poll_edition('standard_edition' .. G.GAME.round_resets.ante, edition_rate, true)
                        local suit = random_suit()
                        create_card.ability.suit = suit
                        SMODS.change_base(create_card, random_suit(), '6')
                        create_card:set_edition(edition, true, true)
                        create_card.ability.edition = edition
                        local seal = SMODS.poll_seal({ mod = 10 })
                        create_card:set_seal(seal)
                        create_card.ability.seal = seal
                        local enhancement = SMODS.poll_enhancement({ mod = 6 })
                        create_card.ability.enhancement = enhancement
                        create_card:set_sprites(G.P_CENTERS[enhancement])
                        area:emplace(create_card)
                        G.GAME.consumeable_buffer = 0
                        return true
                    end,
                }))
            end
            return true
        end
        return nil
    end
}