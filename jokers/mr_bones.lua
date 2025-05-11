return {
    key = "mr_bones",
    calculate = function(self, card, context)
        if
            context.end_of_round
            and context.game_over
            and G.GAME.chips / G.GAME.blind.chips >= 0.25
        then
            SMODS.restart_game()
        end
    end,
}
