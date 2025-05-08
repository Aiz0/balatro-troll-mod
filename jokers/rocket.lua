local alien_sound_count = 12
local mod_prefix = SMODS.current_mod.prefix

for i = 1, alien_sound_count do
    SMODS.Sound({
        key = "alien_" .. i,
        path = "alien_" .. i .. ".ogg"
    })
end

local function play_random_alien(pitch)
    local sound = math.floor(math.random() * (alien_sound_count - 1) + 0.5 + 1)
    play_sound(mod_prefix .. "_alien_" .. sound, pitch)
end

SMODS.Atlas({
    key = "aliens",
    path = "aliens.png",
    px = 71,
    py = 95,
})

SMODS.Joker({
    key = "alien",
    rarity = 1,
    atlas = "folly_aliens",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 1, y = 0 },
    config = {
        extra = {
            low = 5,
            high = 50,
            chips = 5,
        },
    },
    no_collection = true,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien(1.25)
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local chips = folly_utils.pseudorandom_range(card.ability.extra.low, card.ability.extra.high, self.key)
            card.ability.extra.chips = folly_utils.round(chips)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end
})

SMODS.Joker({
    key = "super_alien",
    rarity = 2,
    atlas = "folly_aliens",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 2, y = 0 },
    config = {
        extra = {
            low = 0,
            high = 20,
            mult = 0,
        },
    },
    no_collection = true,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien(1)
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local mult = folly_utils.pseudorandom_range(card.ability.extra.low, card.ability.extra.high, self.key)
            card.ability.extra.mult = folly_utils.round(mult)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end
})

SMODS.Joker({
    key = "giga_alien",
    rarity = 3,
    atlas = "folly_aliens",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 3, y = 0 },
    config = {
        extra = {
            low = 1,
            high = 5,
            mult = 1,
        },
    },
    no_collection = true,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.mult,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien(0.75)
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local mult = folly_utils.pseudorandom_range(card.ability.extra.low, card.ability.extra.high, self.key)
            card.ability.extra.mult = mult
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end
})

SMODS.Joker({
    key = "glorp_alien",
    rarity = 4,
    atlas = "folly_aliens",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 4, y = 0 },
    config = {
        extra = {
            low = 0,
            high = 0.5,
            x_mult = 1,
        },
    },
    no_collection = true,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.x_mult,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien(1.5)
                            return true
                        end
                    }))
                end
            }
        end

        if not context.blueprint and context.using_consumeable and context.consumeable.ability.name == "c_folly_strange_planet" then
            card.ability.extra.x_mult = card.ability.extra.x_mult + folly_utils.pseudorandom_range(card.ability.extra.low, card.ability.extra.high, self.key)
            return {
                message = localize('k_folly_glorp')
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.low,
                card.ability.extra.high,
                card.ability.extra.x_mult
            }
        }
    end
})

SMODS.Consumable({
    key = "strange_planet",
    atlas = "folly_consumables",
    pos = { x = 0, y = 0 },
    set = "Planet",
    --no_collection = true,
    in_pool = function(self, args)
        if next(SMODS.find_card("j_folly_rocket")) then
            -- I could technically return the result from the next but it feels weird
            return true
        end
        return false
    end,
    use = function(self, card, area, copier)
        local ran = pseudorandom(self.key)
        local alien = "j_folly"
        if ran > 0.9 then
            alien = alien .. "_super"
        elseif ran > 0.7 then
            alien = alien .. "_giga"
        elseif ran > 0.4 then
            alien = alien .. "_glorp"
        end
        alien = alien .. "_alien"

        SMODS.add_card({
            key = alien,
            area = G.jokers
        })
        play_sound("tarot2", 0.5)
    end,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit
    end
})

return {
    key = "rocket",
}

