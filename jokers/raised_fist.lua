return {
    key = "raised_fist",
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            -- get lowest card, same as normal
            local temp_ID = math.huge
            local raised_card = nil
            for i = 1, #G.hand.cards do
                if temp_ID >= G.hand.cards[i].base.id and not SMODS.has_no_rank(G.hand.cards[i]) then
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card and not context.other_card.debuff then
                local new_rank = SMODS.Ranks[context.other_card.base.value].key
                G.E_MANAGER:add_event(Event({
                    func = function()
                        -- get next card rank same way strength does
                        -- multiple times so card is essentially doubled
                        for i = 1, raised_card.base.nominal do
                            local rank_data = SMODS.Ranks[new_rank]
                            local behavior = rank_data.strength_effect or { fixed = 1, ignore = false, random = false }
                            if behavior.ignore or not next(rank_data.next) then
                            elseif behavior.random then
                                new_rank = pseudorandom_element(rank_data.next, pseudoseed(self.key))
                            else
                                local ii = (behavior.fixed and rank_data.next[behavior.fixed]) and behavior.fixed or 1
                                new_rank = rank_data.next[ii]
                            end
                        end
                        assert(SMODS.change_base(raised_card, nil, new_rank))
                        return true
                    end,
                }))
            end
        end
    end,
}
