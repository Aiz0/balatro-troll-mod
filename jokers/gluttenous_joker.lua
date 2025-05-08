return {
    key = "gluttenous_joker",
    calculate = function(self, card, context)
        if context.destroy_card and context.cardarea == G.play and context.destroy_card:is_suit("Clubs") then
            if pseudorandom(self.key) < G.GAME.probabilities.normal / 6 then
                return { remove = true, message = localize("k_folly_gluttenous") }
            end
        end
    end,
}
