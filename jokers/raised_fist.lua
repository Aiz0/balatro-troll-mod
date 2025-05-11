return {
    key = "raised_fist",
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand and not context.end_of_round then
            -- get lowest card, same as normal
            local temp_ID = math.huge
            local raised_card = nil
            for i = 1, #G.hand.cards do
                if
                    temp_ID >= G.hand.cards[i].base.id and not SMODS.has_no_rank(G.hand.cards[i])
                then
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card and not context.other_card.debuff then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        assert(SMODS.modify_rank(raised_card, raised_card.base.nominal))
                        return true
                    end,
                }))
            end
        end
    end,
}
