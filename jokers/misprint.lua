return {
    key = "misprint",
    calculate = function(self, card, context)
        if
        context.joker_main then
            if pseudorandom(self.key) > 0.5 then
                return { mult = 23 }
            else
                return { mult = 0 }
            end
        end
    end,
}