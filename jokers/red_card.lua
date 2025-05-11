local colours = {
    red = {
        next = "blue",
        loc_key = "j_folly_red_card",
        pos = { x = 0, y = 2 },
        message_colour = G.C.RED,
    },
    blue = {
        next = "yellow",
        loc_key = "j_folly_blue_card",
        pos = { x = 1, y = 2 },
        message_colour = G.C.BLUE,
    },
    yellow = {
        next = "green",
        loc_key = "j_folly_yellow_card",
        pos = { x = 2, y = 2 },
        message_colour = G.C.YELLOW,
    },
    green = {
        next = "red",
        loc_key = "j_folly_green_card",
        pos = { x = 3, y = 2 },
        message_colour = G.C.GREEN,
    },
}

return {
    key = "red_card",
    name = "fj_red_card",
    atlas = "folly_jokers",
    pos = { x = 0, y = 2 },
    config = {
        extra = {
            colour = "red",
            triggers = 0,
            mult = 3,
            chips = 10,
            money = 1,
            probability = 0.2,
        },
    },
    calc_dollar_bonus = function(self, card)
        if card.ability.extra.colour == "yellow" then
            return card.ability.extra.money * card.ability.extra.triggers
        end
    end,
    add_to_deck = function(self, card, from_debuff)
        if card.ability.extra.colour == "green" then
            self.update_probabilities(card)
        end
    end,
    remove_from_deck = function(self, card, from_debuff)
        local old = card.ability.extra.colour
        card.ability.extra.colour = "red"
        card.ability.extra.triggers = card.ability.extra.triggers + 1
        self.update_probabilities(card)
        card.ability.extra.colour = old
    end,
    set_sprites = function(self, card, front)
        if card.ability then
            local colour = colours[card.ability.extra.colour]
            card.children.center:set_sprite_pos(colour.pos)
        end
    end,
    calculate = function(self, card, context)
        if context.skipping_booster and not context.blueprint then
            card.ability.extra.triggers = card.ability.extra.triggers + 1
            self:switch_colour(card)
            --red by default
            local vars = { card.ability.extra.mult }
            if card.ability.extra.colour == "blue" then
                vars = { card.ability.extra.chips }
            end
            if card.ability.extra.colour == "yellow" then
                vars = { card.ability.extra.money }
            end
            if card.ability.extra.colour == "green" then
                vars = { card.ability.extra.probability }
            end
            return {
                message = localize({
                    type = "variable",
                    key = "a_folly_" .. card.ability.extra.colour .. "_card",
                    vars = vars,
                }),
                colour = colours[card.ability.extra.colour].message_colour,
            }
        end

        if context.joker_main then
            if card.ability.extra.colour == "red" then
                return {
                    mult = card.ability.extra.mult * card.ability.extra.triggers,
                }
            end
            if card.ability.extra.colour == "blue" then
                return {
                    chips = card.ability.extra.chips * card.ability.extra.triggers,
                }
            end
        end
    end,
    loc_vars = function(self, info_queue, card)
        --red by default
        local vars =
            { card.ability.extra.mult, card.ability.extra.mult * card.ability.extra.triggers }
        if card.ability.extra.colour == "blue" then
            vars =
                { card.ability.extra.chips, card.ability.extra.chips * card.ability.extra.triggers }
        end
        if card.ability.extra.colour == "yellow" then
            vars =
                { card.ability.extra.money * card.ability.extra.triggers, card.ability.extra.money }
        end
        if card.ability.extra.colour == "green" then
            vars = {
                card.ability.extra.probability * card.ability.extra.triggers,
                card.ability.extra.probability,
            }
        end
        return {
            key = colours[card.ability.extra.colour].loc_key,
            vars = vars,
        }
    end,

    switch_colour = function(self, card)
        local prev = card.ability.extra.colour
        local next = colours[card.ability.extra.colour].next
        local colour = colours[next]

        card.ability.extra.colour = next
        card.children.center:set_sprite_pos(colour.pos)

        if next == "green" or prev == "green" then
            self.update_probabilities(card)
        end
    end,

    update_probabilities = function(card)
        local oops = SMODS.find_card("j_oops")
        local probability_mult = 1
        if next(oops) then
            probability_mult = 2 ^ #oops
        end
        local triggers = card.ability.extra.triggers
        if card.ability.extra.colour ~= "green" then
            triggers = triggers - 1
        end
        local probability = triggers * card.ability.extra.probability * probability_mult

        if card.ability.extra.colour == "green" then
            for i, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[i] = G.GAME.probabilities[i] + probability
            end
        else
            for i, v in pairs(G.GAME.probabilities) do
                G.GAME.probabilities[i] = G.GAME.probabilities[i] - probability
            end
        end
    end,
}
