local alien_sound_count = 8
local mod_prefix = SMODS.current_mod.prefix

for i = 1, alien_sound_count do
    SMODS.Sound({
        key = "alien_"..i,
        path = "alien_"..i..".ogg"
    })
end

local function play_random_alien()
    local sound = math.floor(math.random() * (alien_sound_count - 1) + 0.5 + 1)
    play_sound(mod_prefix.."_alien_"..sound)
end

SMODS.ObjectType({
    key = "alien",
    default = "j_folly_alien",
    cards = {
        ["j_folly_alien"] = true,
        ["j_folly_super_alien"] = true,
        ["j_folly_giga_alien"] = true,
        ["j_folly_glorp_alien"] = true,
    },
    rarities = {
        { key = "Common", rate = 0.4 },
        { key = "Uncommon", rate = 0.3 },
        { key = "Rare", rate = 0.2 },
        { key = "Legendary", rate = 0.1 },
    },
})

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
        no_collection = true,
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                chips = card.ability.extra.chips,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien()
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local ran = pseudorandom(self.key)
            local chips = folly_utils.lerp(card.ability.extra.low, card.ability.extra.high, ran)
            card.ability.extra.chips = math.floor(chips + 0.5)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.chips }}
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
        no_collection = true,
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                mult = card.ability.extra.mult,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien()
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local ran = pseudorandom(self.key)
            local mult = folly_utils.lerp(card.ability.extra.low, card.ability.extra.high, ran)
            card.ability.extra.mult = math.floor(mult + 0.5)
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult }}
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
        no_collection = true,
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                x_mult = card.ability.extra.mult,
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien()
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
            local ran = pseudorandom(self.key)
            local mult = folly_utils.lerp(card.ability.extra.low, card.ability.extra.high, ran)
            card.ability.extra.mult = mult
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult }}
    end
})

SMODS.Joker({
    key = "glorp_alien",
    rarity = 4,
    atlas = "folly_aliens",
    pos = { x = 0, y = 0 },
    soul_pos = { x = 4, y = 0 },
    config = {
        no_collection = true,
    },
    calculate = function(self, card, context)
        if context.joker_main then
            return {
                func = function()
                    G.E_MANAGER:add_event(Event({
                        trigger = "after",
                        func = function()
                            play_random_alien()
                            return true
                        end
                    }))
                end
            }
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if not from_debuff then
        end
    end,
})

SMODS.Consumable({
    key = "strange_planet",
    atlas = "folly_consumables",
    pos = { x = 0, y = 0 },
    set = "Planet",
    config = {
        no_collection = true,  
    },
    in_pool = function(self, args)
        if next(SMODS.find_card("j_folly_rocket")) then -- I could technically return the result from the next but it feels weird
            return true
        end
        return false
    end,
    use = function(self, card, area, copier)
        SMODS.add_card({
            set = "alien",
            area = G.jokers
        })
    end,
    can_use = function(self, card)
        return #G.jokers.cards < G.jokers.config.card_limit
    end
})

return {
    key = "rocket",
}