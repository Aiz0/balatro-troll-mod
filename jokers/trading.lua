SMODS.Atlas({
    key = "trading",
    path = "trading_card.png",
    px = 71,
    py = 95,
})

return {
    calculate = function(self, card, context)
        if context.first_hand_drawn and not context.blueprint then
            local eval = function()
                return G.GAME.current_round.discards_used == 0 and not G.RESET_JIGGLES
            end
            juice_card_until(card, eval, true)
        end

        if context.discard
                and not context.blueprint
                and G.GAME.current_round.discards_used <= 0 and #context.full_hand <= card.ability.extra.discards then
            local playing_card = {
                attack = context.other_card.base.nominal,
                health = context.other_card.base.id - 1,
            }
            card.ability.extra.health = card.ability.extra.health - playing_card.attack
            if card.ability.extra.health <= 0 then
                card:shatter();
                SMODS.calculate_effect({ message = card.ability.extra.attack .. localize("k_folly_tc_dead"), colour = G.C.BLUE }, context.other_card)
            end

            if card.ability.extra.attack < playing_card.health then
                SMODS.calculate_effect({ message = card.ability.extra.attack .. localize("k_folly_tc_damage"), colour = G.C.BLUE }, context.other_card)
                SMODS.modify_rank(context.other_card, -card.ability.extra.attack)
                self.update_atlas_stats(card)
                return
            else
                ease_dollars(card.ability.extra.money)
                self.add_level(card, self.level_stat_sheet)
                self.update_atlas_stats(card)
                return {
                    message = localize('$') .. card.ability.extra.money,
                    colour = G.C.MONEY,
                    delay = 0.45,
                    remove = true,
                }
            end
        end

        if context.end_of_round and context.cardarea == G.jokers then
            card.ability.extra.health = card.ability.extra.max_health
            SMODS.calculate_effect({ message = localize("k_folly_tc_heal"), colour = G.C.BLUE }, card)
            self.update_atlas_stats(card)
        end
    end,

    loc_vars = function(self, info_queue, card)
        local key = self.key.."_alt"
        if card.ability.extra.discards > 1 then key = key.."_multiple" end
        return { 
            key = key,
            vars = {
            card.ability.extra.discards,
            card.ability.extra.money,
        }, }
    end,

    level_stat_sheet = {
        { discards = 1, attack = 4, max_health = 3, money = 3 }, -- 1
        { discards = 1, attack = 4, max_health = 4, money = 3 }, -- 2
        { discards = 1, attack = 4, max_health = 5, money = 3 }, -- 3
        { discards = 1, attack = 5, max_health = 6, money = 3 }, -- 4
        { discards = 1, attack = 5, max_health = 7, money = 4 }, -- 5
        { discards = 1, attack = 5, max_health = 8, money = 4 }, -- 6
        { discards = 1, attack = 6, max_health = 9, money = 4 }, -- 7
        { discards = 2, attack = 6, max_health = 10, money = 4 }, -- 8
        { discards = 2, attack = 7, max_health = 11, money = 5 }, -- 9
        { discards = 2, attack = 7, max_health = 12, money = 5 }, -- 10
        { discards = 2, attack = 8, max_health = 13, money = 5 }, -- 11
        { discards = 2, attack = 8, max_health = 14, money = 5 }, -- 12
        { discards = 2, attack = 9, max_health = 15, money = 6 }, -- 13
        { discards = 2, attack = 9, max_health = 16, money = 6 }, -- 14
        { discards = 3, attack = 10, max_health = 17, money = 6 }, -- 15
        { discards = 3, attack = 10, max_health = 18, money = 6 }, -- 16
        { discards = 3, attack = 11, max_health = 19, money = 7 }, -- 17
        { discards = 3, attack = 12, max_health = 19, money = 7 }, -- 18
        { discards = 3, attack = 13, max_health = 20, money = 7 }, -- 19
        { discards = 3, attack = 14, max_health = 20, money = 7 }, -- 20
    },

    add_level = function(card, sheet)
        if card.ability.extra.level == 20 then
            return
        end
        card.ability.extra.level = math.min(card.ability.extra.level + 1, 20)
        SMODS.calculate_effect({ message = localize("k_folly_tc"), colour = G.C.BLUE }, card)
        local level_stats = sheet[card.ability.extra.level]
        card.ability.extra.discards = level_stats.discards
        card.ability.extra.attack = level_stats.attack
        card.ability.extra.max_health = level_stats.max_health
        card.ability.extra.money = level_stats.money
    end,
    
    update_atlas_stats = function(card)
        card.children.center:set_sprite_pos({ x = card.ability.extra.attack - 4, y = card.ability.extra.health - 1 })
    end,
    key = "trading",
    name = "fj_trading",
    atlas = "folly_trading",
    pos = { x = 0, y = 2 },
    config = {
        extra = {
            discards = 1,
            level = 1,
            attack = 4,
            max_health = 3,
            health = 3,
            money = 3,
        },
        name = "fj_trading",
    },
    set_sprites = function(self, card, front)
        if card.ability then
            self.update_atlas_stats(card)
        end
    end,
}