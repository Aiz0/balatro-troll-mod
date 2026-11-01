local madness_events = {
    joker = 0,
    money = 1,
    hands = 2,
    discards = 3,
    hand_size = 4,
    playing_card = 5,
    consumable = 6,
}

return {
    key = "madness",
    name = "fj_madness",
    config = {
        extra = {
            consumed = {
                joker = 0,
                money = 0,
                hands = 0,
                discards = 0,
                hand_size = 0,
                playing_card = 0,
                consumable = 0,
            },

            should_eat_playing_card = false,
        },
    },
    calculate = function(self, card, context)
        if
            context.setting_blind
            and not card.getting_sliced
            and not context.blueprint
            and not context.blind.boss
        then
            local event = pseudorandom_element(madness_events, pseudoseed(self.key))

            -- eat joker
            if event == madness_events.joker then
                card.ability.extra.consumed.joker = card.ability.extra.consumed.joker + 1
                local destructable_jokers = {}
                for i = 1, #G.jokers.cards do
                    if
                        G.jokers.cards[i] ~= card
                        and not G.jokers.cards[i].ability.eternal
                        and not G.jokers.cards[i].getting_sliced
                    then
                        destructable_jokers[#destructable_jokers + 1] = G.jokers.cards[i]
                    end
                end
                local joker_to_destroy = #destructable_jokers > 0
                        and pseudorandom_element(destructable_jokers, pseudoseed(self.key))
                    or nil

                if joker_to_destroy and not (context.blueprint_card or card).getting_sliced then
                    joker_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            (context.blueprint_card or card):juice_up(0.8, 0.8)
                            joker_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end,
                    }))
                end
            end

            -- I really wish I could just do a switch statement
            -- eat money
            if event == madness_events.money then
                card.ability.extra.consumed.money = card.ability.extra.consumed.money
                    + G.GAME.dollars
                ease_dollars(-G.GAME.dollars)
            end

            -- eat hands per round
            if event == madness_events.hands then
                card.ability.extra.consumed.hands = card.ability.extra.consumed.hands + 1
                G.GAME.round_resets.hands = G.GAME.round_resets.hands - 1
                ease_hands_played(-1)
            end

            -- eat discards per round
            if event == madness_events.discards then
                card.ability.extra.consumed.discards = card.ability.extra.consumed.discards + 1
                G.GAME.round_resets.discards = G.GAME.round_resets.discards - 1
                ease_discard(-1)
            end

            -- eat hand size
            if event == madness_events.hand_size then
                card.ability.extra.consumed.hand_size = card.ability.extra.consumed.hand_size + 1
                G.hand:change_size(-1)
            end

            -- eat playing card
            if event == madness_events.playing_card then
                card.ability.extra.consumed.should_eat_playing_card = true
            end

            if event == madness_events.consumable then
                local consumable_to_destroy = #G.consumeables.cards > 0
                        and pseudorandom_element(G.consumeables.cards, pseudoseed(self.key))
                    or nil
                card.ability.extra.consumed.consumable = card.ability.extra.consumed.consumable + 1
                if
                    consumable_to_destroy and not (context.blueprint_card or card).getting_sliced
                then
                    consumable_to_destroy.getting_sliced = true
                    G.E_MANAGER:add_event(Event({
                        func = function()
                            consumable_to_destroy:start_dissolve({ G.C.RED }, nil, 1.6)
                            return true
                        end,
                    }))
                    if consumable_to_destroy.ability.set == "Spectral" then
                        card.ability.extra.consumed.consumable = card.ability.extra.consumed.consumable
                            + 1
                    end
                end
            end

            if
                not (context.blueprint_card or card).getting_sliced
                and event ~= madness_events.playing_card
            then
                (context.blueprint_card or card):juice_up(0.8, 0.8)
                SMODS.calculate_effect(
                    {
                        message = localize({
                            type = "variable",
                            key = "a_xmult",
                            vars = { self.calculate_x_mult(card) },
                        }),
                    },
                    card or context.blueprint_card
                )
            end
        end

        if
            context.first_hand_drawn
            and not card.getting_sliced
            and not context.blueprint
            and card.ability.extra.consumed.should_eat_playing_card
        then
            card.ability.extra.consumed.should_eat_playing_card = false
            local destroyed_card = pseudorandom_element(G.hand.cards, pseudoseed(self.key))
            if SMODS.shatters(destroyed_card) then
                destroyed_card:shatter()
            else
                destroyed_card:start_dissolve()
            end
            delay(0.3)
            card.ability.extra.consumed.playing_card = card.ability.extra.consumed.playing_card
                + destroyed_card.base.nominal
            SMODS.calculate_context({ remove_playing_cards = true, removed = { destroyed_card } })
            delay(0.5)
            if not (context.blueprint_card or card).getting_sliced then
                (context.blueprint_card or card):juice_up(0.8, 0.8)
                SMODS.calculate_effect(
                    {
                        message = localize({
                            type = "variable",
                            key = "a_xmult",
                            vars = { self.calculate_x_mult(card) },
                        }),
                    },
                    card or context.blueprint_card
                )
            end
        end

        if context.joker_main then
            local ret = self.calculate_x_mult(card)
            if ret ~= 1 then
                return {
                    x_mult = self.calculate_x_mult(card),
                }
            end
        end
    end,
    calculate_x_mult = function(card)
        local x = 1.0
        x = x + card.ability.extra.consumed.joker * 0.5
        x = x + card.ability.extra.consumed.money * 0.01
        x = x + card.ability.extra.consumed.hands * 1.5
        x = x + card.ability.extra.consumed.discards * 1.5
        x = x + card.ability.extra.consumed.hand_size * 1.5
        x = x + card.ability.extra.consumed.playing_card * 0.025
        x = x + card.ability.extra.consumed.consumable * 0.1
        return x
    end,
    generate_ui = function(self, info_queue, card, desc_nodes, specific_vars, full_UI_table)
        full_UI_table.name =
            localize({ type = "name", key = self.key, set = self.set, nodes = full_UI_table.name })
        localize({
            type = "descriptions",
            key = self.key,
            set = self.set,
            nodes = desc_nodes,
            vars = { 0.5, self.calculate_x_mult(card) },
        })
        local added = false
        for k, v in pairs(card.ability.extra.consumed) do
            if v > 0 then
                if not added then
                    full_UI_table.info[#full_UI_table.info + 1] = {}
                    desc_nodes = full_UI_table.info[#full_UI_table.info]
                    desc_nodes.name =
                        localize({ type = "name_text", set = "Other", key = "madness_eaten" })
                    added = true
                end
                desc_nodes[#desc_nodes + 1] = localize({
                    type = "text",
                    key = "a_folly_madness_" .. k,
                    nodes = desc_nodes,
                    vars = { v },
                })
            end
        end
    end,
}
