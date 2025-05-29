return {
    key = "fortune_teller",
    calculate = function(self, card, context)
        if context.end_of_round and not context.individual and not context.repetition then
            return {
                message = localize({
                    type = "variable",
                    key = "a_folly_fortune_teller",
                    vars = { G.GAME.dollars + (G.GAME.dollar_buffer or 0) },
                }),
                colour = G.C.MONEY,
            }
        end
    end,
}
