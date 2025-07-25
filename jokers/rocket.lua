local alien_sound_count = 12

for i = 1, alien_sound_count do
    SMODS.Sound({
        key = "alien_" .. i,
        path = "alien_" .. i .. ".ogg",
    })
end

local function play_random_alien(pitch)
    local sound = math.random(alien_sound_count)
    play_sound(folly_utils.prefix.mod .. "_alien_" .. sound, pitch)
end

SMODS.Joker({
    key = "alien",
    rarity = 1,
    atlas = "folly_jokers",
    pos = { x = 0, y = 1 },
    soul_pos = { x = 1, y = 1 },
    config = {
        extra = {
            low = 0,
            high = 100,
            chips = 5,
        },
    },
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
                        end,
                    }))
                end,
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local chips = folly_utils.pseudorandom_range(
            card.ability.extra.low,
            card.ability.extra.high,
            self.key
        )
        card.ability.extra.chips = round_number(chips, 0)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips } }
    end,
})

SMODS.Joker({
    key = "super_alien",
    rarity = 2,
    atlas = "folly_jokers",
    pos = { x = 0, y = 1 },
    soul_pos = { x = 2, y = 1 },
    config = {
        extra = {
            low = 0,
            high = 30,
            mult = 0,
        },
    },
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
                        end,
                    }))
                end,
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local mult = folly_utils.pseudorandom_range(
            card.ability.extra.low,
            card.ability.extra.high,
            self.key
        )
        card.ability.extra.mult = round_number(mult, 0)
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
})

SMODS.Joker({
    key = "giga_alien",
    rarity = 3,
    atlas = "folly_jokers",
    pos = { x = 0, y = 1 },
    soul_pos = { x = 3, y = 1 },
    config = {
        extra = {
            low = 1,
            high = 5,
            x_mult = 1,
        },
    },
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
                            play_random_alien(0.75)
                            return true
                        end,
                    }))
                end,
            }
        end
    end,
    set_ability = function(self, card, initial, delay_sprites)
        local x_mult = folly_utils.pseudorandom_range(
            card.ability.extra.low,
            card.ability.extra.high,
            self.key
        )
        card.ability.extra.x_mult = x_mult
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.x_mult } }
    end,
})

SMODS.Joker({
    key = "glorp_alien",
    rarity = 4,
    atlas = "folly_jokers",
    pos = { x = 0, y = 1 },
    soul_pos = { x = 4, y = 1 },
    config = {
        extra = {
            low = 0,
            high = 0.5,
            x_mult = 1,
        },
    },
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.joker_main and card.ability.extra.x_mult > 1 then
            return {
                x_mult = card.ability.extra.x_mult,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien(1.5)
                            return true
                        end,
                    }))
                end,
            }
        end

        if
            not context.blueprint
            and context.using_consumeable
            and context.consumeable.ability.name == "c_folly_strange_planet"
        then
            card.ability.extra.x_mult = card.ability.extra.x_mult
                + folly_utils.pseudorandom_range(
                    card.ability.extra.low,
                    card.ability.extra.high,
                    self.key
                )
            return {
                message = localize("k_folly_glorp"),
            }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return {
            vars = {
                card.ability.extra.low,
                card.ability.extra.high,
                card.ability.extra.x_mult,
            },
        }
    end,
})

SMODS.Consumable({
    key = "strange_planet",
    atlas = "folly_consumables",
    pos = { x = 0, y = 0 },
    set = "Planet",
    in_pool = function(self, args)
        return next(SMODS.find_card("j_folly_rocket")) ~= nil
    end,
    use = function(self, card, area, copier)
        local ran = pseudorandom(self.key)
        local alien = "j_folly_"
        if ran > 0.95 then
            alien = alien .. "glorp_"
        elseif ran > 0.8 then
            alien = alien .. "giga_"
        elseif ran > 0.5 then
            alien = alien .. "super_"
        end
        alien = alien .. "alien"

        SMODS.add_card({
            key = alien,
        })
        play_sound("tarot2", 0.5)
    end,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit
    end,
})

return {
    key = "rocket",
}
