return {
    key = "misprint",
    calculate = function(self, card, context)
        if context.joker_main then
            if pseudorandom(self.key) > 0.5 then
                return { mult = card.ability.extra.min }
            else
                return { mult = card.ability.extra.max }
            end
        end
    end,
}
