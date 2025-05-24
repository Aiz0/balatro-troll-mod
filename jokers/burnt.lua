SMODS.Enhancement({
    key = "burnt",
    atlas = "folly_enhancers",
    pos = { x = 0, y = 0 },
    weight = 0,
    in_pool = function(self, args)
        return false
    end,
    config = {
        extra = {
            base_gain = 2,
        },
    },
    burn = 0, --Static member, mult gained for each burnt card played
    calculate = function(self, card, context)
        if context.before then
            self.burn = 0
        end
        if context.main_scoring and context.cardarea == G.play then
            self.burn = self.burn + card.ability.extra.base_gain
            return {
                mult = self.burn,
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.base_gain,
        } }
    end,
})

SMODS.Sound({
    key = "it_burns",
    path = "it_burns.ogg",
})

local mod_prefix = SMODS.current_mod.prefix
return {
    key = "burnt",
    calculate = function(self, card, context)
        if context.discard and context.other_card then
            local other_card = context.other_card
            if
                other_card.config.center ~= G.P_CENTERS.m_folly_burnt
                and pseudorandom(self.key) < G.GAME.probabilities.normal / 20
            then
                other_card:set_ability(G.P_CENTERS.m_folly_burnt, nil, true)
                G.E_MANAGER:add_event(Event({
                    delay = 1,
                    trigger = "before",
                    func = function()
                        play_sound(mod_prefix .. "_it_burns")
                        other_card:juice_up()
                        return true
                    end,
                }))
            end
        end
    end,
}
