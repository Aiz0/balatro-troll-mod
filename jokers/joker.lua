return {
    key = "joker",
    cost = 99,
    calculate = function(self, card, context)
        if context.joker_main then return { mult = 3 } end
    end,
}
