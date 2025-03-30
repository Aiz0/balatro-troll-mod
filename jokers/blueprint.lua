SMODS.Joker({
    key = "apartment",
    config = {
        extra = 0,
    },
    cost = 10,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand then
            local temp_Chips, temp_ID = 15, 15
            local raised_card = nil
            for i = 1, #G.hand.cards do
                if temp_ID >= G.hand.cards[i].base.id and G.hand.cards[i].ability.effect ~= 'Stone Card' then
                    temp_Chips = G.hand.cards[i].base.nominal
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card
                    }
                else
                    card.ability.extra = card.ability.extra + temp_Chips
                    return {
                        message = "+" .. temp_Chips,
                        colour = G.C.CHIPS,
                        card = card
                    }
                end
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra,
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "Apartment",
        text = {
            "This Joker gains",
            "Chips equal to the",
            "{C:attention}lowest{} ranked card",
            "held in hand",
            "{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

SMODS.Joker({
    key = "house",
    cost = 10,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult or 0
            context.other_card.ability.perma_mult = context.other_card.ability.perma_mult + 1
            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                colour = G.C.MULT,
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "House",
        text = {
            "Every played {C:attention}card{}",
            "permanently gains",
            "{C:mult}+1{} Mult when scored",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

function remove_weird_freaky_invisible_cards(card_table)
    for i, v in pairs(card_table) do
        v:remove()
    end
    card_table = {}
end

SMODS.Joker({
    key = "mansion",
    cost = 10,
    config = {
        extra = {
            xmult_mod = 0.02,
            xmult = 1,
            marked_for_remove = {}
        }
    },
    in_pool = function(self, args)
        return false
    end,
    remove_from_deck = function(self, card, from_debuff)
        remove_weird_freaky_invisible_cards(card.ability.extra.marked_for_remove)
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                if v.base.nominal == 2 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            v:start_dissolve({HEX("57ecab")}, nil, 1);
                            table.insert(card.ability.extra.marked_for_remove, v)
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            SMODS.modify_rank(v, -1)
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end

            return {
                message = "Evil Billionaire Power",
                colour = G.C.RED,
                card = card
            }
        end

        if context.end_of_round and context.cardarea == G.jokers then
            remove_weird_freaky_invisible_cards(card.ability.extra.marked_for_remove)
        end
        
        if context.joker_main and card.ability.extra.xmult ~= 1 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "Mansion",
        text = {
            "Reduces rank of",
            "all {C:attention}scoring cards{}",
            "in played hand",
            "Gain {X:red,C:white}X#1#{} Mult",
            "per rank reduced",
            "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { 
            card.ability.extra.xmult_mod,
            card.ability.extra.xmult,
        } }
    end,
})

return {
    key = "blueprint"
}
