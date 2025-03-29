SMODS.Sound({
    key = "marbles",
    path = "marbles.ogg",
})

local mod_prefix = SMODS.current_mod.prefix
return {
    key = "marble",
    calculate = function(self, card, context)
        if context.setting_blind then play_sound(mod_prefix .. "_marbles", nil, 0.1) end
    end,
}
