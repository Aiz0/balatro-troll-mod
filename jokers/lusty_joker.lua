return {
    key = "lusty_joker",
    calculate = function(self, card, context)
        if context.joker_main then return { message = "I'll Giggity Lois" } end
    end,
}
