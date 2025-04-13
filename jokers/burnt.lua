SMODS.Enhancement({
    key = "burnt",
    atlas = "folly_enhancers",
    pos = { x = 0, y = 0 },
    min = 0.5,
    max = 1.5,
    replace_base_card = true,
    no_rank = true,
    no_suit = true,
    overrides_base_rank = true,
    always_scores = true,
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            return {
                x_mult = folly_utils.lerp(self.min, self.max * G.GAME.probabilities.normal, pseudorandom(self.key))
            }
        end
    end,
    loc_txt = G.localization.descriptions.Enhanced.m_folly_burnt,
    loc_vars = function(self, info_queue, card)
        return { vars = {
            self.min,
            self.max * G.GAME.probabilities.normal,
        }, }
    end,
})

SMODS.Sound({
    key = "it_burns",
    path = "it_burns.ogg"
})

local mod_prefix = SMODS.current_mod.prefix
return {
    key = "burnt",
    calculate = function(self, card, context)
        if context.individual then
            local other_card = context.other_card
            if other_card.config.center ~= G.P_CENTERS.m_folly_burnt and pseudorandom(self.key) < G.GAME.probabilities.normal / 12 then
                G.E_MANAGER:add_event(Event({
                    delay = 1,
                    func = function()
                        play_sound(mod_prefix .. "_it_burns")
                        other_card:juice_up()
                        return true
                    end
                }))
                other_card:set_ability(G.P_CENTERS.m_folly_burnt, nil, true)
            end
        end
    end
}