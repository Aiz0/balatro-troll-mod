return {
    key = "misprint",
    calculate = function(self, card, context)
        if
        context.joker_main then
            local planets_used = 0
            for k, v in pairs(G.GAME.consumeable_usage) do
                if v.set == 'Planet' then planets_used = planets_used + 1 end
            end
        end
    end,
}