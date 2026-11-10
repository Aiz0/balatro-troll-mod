return {
    key = "greedy_joker",
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            return {
                message = localize("k_folly_greed"),
                dollars = -1,
            }
        end
    end,
}
