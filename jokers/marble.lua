SMODS.Sound({
    key = "marbles",
    path = "marbles.ogg",
})

return {
    key = "marble",
    calculate = function(self, card, context)
        if context.setting_blind and not card.getting_sliced then
            play_sound(folly_utils.prefix.mod .. "_marbles", nil, 0.1)
        end
    end,
}
