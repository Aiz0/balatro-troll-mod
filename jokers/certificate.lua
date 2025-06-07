--                      2, 3, 4, 5, 6, 7, 8, 9, 10,J, Q, K, A
local rank_approval = { 2, 2, 2, 2, 2, 1, 1, 2, 2, 3, 3, 4, 2 }
local suit_approval = { Spades = 1, Clubs = 2, Diamonds = 3, Hearts = 4 }
local enhancement_approval = { ["Bonus"] = 1, ["Mult"] = 2, ["Wild Card"] = 1, ["Glass Card"] = 4, ["Steel Card"] = 3, ["Stone Card"] = 1, ["Gold Card"] = 3, ["Lucky Card"] = 3 }
local editions_approval = { ["foil"] = 2, ["holo"] = 3, ["polychrome"] = 4, ["negative"] = 4 }

SMODS.Seal({
    key = "approval",
    atlas = "folly_seals",
    pos = { x = 0, y = 0 },
    badge_colour = HEX("3eb71c"),
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local approval = 1
            if card.base.id - 1 <= #rank_approval then
                approval = approval * rank_approval[card.base.id - 1]
            end
            if suit_approval[card.base.suit] then
                approval = approval * suit_approval[card.base.suit]
            end
            if enhancement_approval[card.config.center.name] then
                approval = approval * enhancement_approval[card.config.center.name]
            end
            if card.edition and editions_approval[card.edition.type] then
                approval = approval * editions_approval[card.edition.type]
            end
            return {
                mult = approval
            }
        end
    end
})

local function spheal_card(card, context)
    local eval = eval_card(card, context)
    if eval.playing_card then
        return function()
            if eval.enhancement then
                folly_utils.merge_numerical_ret_values(eval.playing_card, eval.enhancement)
            end
            if eval.seals then
                folly_utils.merge_numerical_ret_values(eval.playing_card, eval.seals)
            end
            SMODS.calculate_effect(eval.playing_card, card, false)
            if eval.edition then
                SMODS.calculate_effect(eval.edition, card, true)
            end
        end
    end
    return nil
end

SMODS.Seal({
    key = "spheal",
    atlas = "folly_seals",
    pos = { x = 1, y = 0 },
    badge_colour = HEX("8c9eff"),
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play and not context.spheal and not card.sphealed then
            local card_index
            for i = 1, #G.play.cards do
                if G.play.cards[i] == card then
                    card_index = i
                    break
                end
            end
            local ret = {}
            local juice_targets = {}
            context.spheal = true
            if card_index - 1 ~= 0 then
                local left_ret = spheal_card(G.play.cards[card_index - 1], context)
                if left_ret then
                    table.insert(juice_targets, left_ret)
                end
            end
            if card_index + 1 <= #G.play.cards then
                local right_ret = spheal_card(G.play.cards[card_index + 1], context)
                if right_ret then
                    table.insert(juice_targets, right_ret)
                end
            end
            context.spheal = nil
            ret.func = function()
                for i, v in pairs(juice_targets) do
                    v()
                end
            end
            ret.message = localize("k_folly_spheal")
            ret.colour = G.C.BLUE
            ret.remove_default_message = true
            card.sphealed = true
            return ret
        end
        if context.after and context.cardarea == G.play then
            card.sphealed = false
        end
    end
})

SMODS.DrawStep({
    key = "folly_glass_shine",
    atlas = "folly_seals",
    order = 60,
    func = function(self)
        if self.seal == "folly_glass" then
            G.shared_seals[self.seal]:draw_shader('voucher', nil, self.ARGS.send_to_shader, nil, self.children.center)
        end
    end
})

SMODS.Gradient({
    key = "fragile",
    colours = {
        HEX("ff0000"),
        HEX("ffffff"),
    },
    cycle = 1.5,
    interpolation = "trig"
})

SMODS.Gradient({
    key = "fragile_inverse",
    colours = {
        HEX("ffffff"),
        HEX("ff0000"),
    },
    cycle = 1.5,
    interpolation = "trig"
})

SMODS.Seal({
    key = "glass",
    atlas = "folly_seals",
    pos = { x = 2, y = 0 },
    badge_colour = HEX("d0d5db"),
    calculate = function(self, card, context)
        if context.repetition then
            --honestly who the fuck invented random anyway?
            local repetitions = folly_utils.pseudorandom_range_rounded(math.min(3, G.GAME.probabilities.normal - 1), 3, self.key)
            if repetitions ~= 0 then
                return { repetitions = repetitions }
            end
        end
        if context.destroy_card and context.destroy_card.seal == "folly_glass" then
            
            return { remove = true }
        end
    end,
    loc_vars = function(self, info_queue, card)
        return { vars = { math.min(3, G.GAME.probabilities.normal - 1) } }
        
    end
})

SMODS.Sound({
    key = "navy",
    path = "navy.ogg"
})

SMODS.Seal({
    key = "navy",
    atlas = "folly_seals",
    pos = { x = 3, y = 0 },
    badge_colour = HEX("000056"),
    seal_height = 0,
    calculate = function(self, card, context)
        if context.before then
            self.seal_height = 0
        end
        if context.hand_drawn and context.cardarea == G.hand then
            card.ability.forced_selection = true
        end
        if context.main_scoring and context.cardarea == G.play then
            local seal = self.seal_height;
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                delay = 1,
                func = function()
                    play_sound("folly_navy", 1 - seal / 10)
                    attention_text({
                        scale = 0.25,
                        text = localize("k_folly_navy_seal"),
                        hold = 135,
                        align = "cm",
                        offset = { x = -1, y = seal },
                        major = G.play,
                    })
                    return true
                end,
            }))
            self.seal_height = self.seal_height - 0.2
        end
    end
})

SMODS.DrawStep({
    key = "folly_gay_poly",
    atlas = "folly_seals",
    order = 60,
    func = function(self)
        if self.seal == "folly_gay" then
            G.shared_seals[self.seal]:draw_shader('polychrome', nil, self.ARGS.send_to_shader, nil, self.children.center)
        end
    end
})

local gay_gradient = SMODS.Gradient({
    key = "gay",
    colours = {
        HEX("A100D2"),
        HEX("2180E9"),
        HEX("82CB02"),
        HEX("F9D200"),
        HEX("FB6F01"),
        HEX("F10000"),
    },
    cycle = 3,
    interpolation = "linear"
})

local function get_gays(hand, rank)
    for _, suit in ipairs(SMODS.Suit.obj_buffer) do
        local gays = {}
        for _, card in ipairs(hand) do
            if
                card:is_suit(suit, nil, true)
                and card:get_seal(true) == "folly_gay"
                and SMODS.Ranks[card.base.value].key == rank
            then
                table.insert(gays, card)
            end
            if SMODS.has_enhancement(card, "m_folly_jimbo") then
                table.insert(gays, card)
            end
            if #gays == 2 then
                return { gays }
            end
        end
    end
    return {}
end

SMODS.PokerHand({
    key = "men",
    chips = 5,
    mult = 10,
    l_chips = 10,
    l_mult = 1,
    example = {
        { "H_K", true, seal = "folly_gay" },
        { "H_K", true, seal = "folly_gay" },
        { "S_J", false },
        { "D_7", false },
        { "C_3", false },
    },
    evaluate = function(parts, hand)
        return get_gays(hand, "King")
    end
})

SMODS.PokerHand({
    key = "women",
    chips = 10,
    mult = 5,
    l_chips = 5,
    l_mult = 2,
    example = {
        { "H_Q", true, seal = "folly_gay" },
        { "H_Q", true, seal = "folly_gay" },
        { "S_J", false },
        { "D_7", false },
        { "C_3", false },
    },
    evaluate = function(parts, hand)
        return get_gays(hand, "Queen")
    end
})

SMODS.PokerHand({
    key = "enby",
    chips = 7,
    mult = 8,
    l_chips = 3,
    l_mult = 3,
    example = {
        { "J_Q", true, seal = "folly_gay" },
        { "J_Q", true, seal = "folly_gay" },
        { "S_J", false },
        { "D_7", false },
        { "C_3", false },
    },
    evaluate = function(parts, hand)
        return get_gays(hand, "Jack")
    end
})

SMODS.Seal({
    key = "gay",
    atlas = "folly_seals",
    pos = { x = 4, y = 0 },
    badge_colour = gay_gradient,
    seal_height = 0,
    calculate = function(self, card, context)
        if context.before then
            self.seal_height = 0
        end
        if context.hand_drawn and context.cardarea == G.hand then
            card.ability.forced_selection = true
        end
        if context.main_scoring and context.cardarea == G.play then
            local seal = self.seal_height;
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                delay = 1,
                func = function()
                    play_sound("folly_navy", 1 - seal / 10)
                    attention_text({
                        scale = 0.25,
                        text = localize("k_folly_navy_seal"),
                        hold = 135,
                        align = "cm",
                        offset = { x = -1, y = seal },
                        major = G.play,
                    })
                    return true
                end,
            }))
            self.seal_height = self.seal_height - 0.2
        end
    end
})

return {
    key = "certificate",
    name = "fj_certificate",
    calculate = function(self, card, context)
        if context.first_hand_drawn then
            local _card = create_playing_card({
                front = pseudorandom_element(G.P_CARDS, pseudoseed('cert_fr')),
                center = G.P_CENTERS.c_base }, G.discard, true, nil, { G.C.SECONDARY_SET.Enhanced }, true)
            _card:set_seal(SMODS.poll_seal({ guaranteed = true, type_key = 'certsl' }))
            G.E_MANAGER:add_event(Event({
                func = function()
                    G.hand:emplace(_card)
                    _card:start_materialize()
                    G.GAME.blind:debuff_card(_card)
                    G.hand:sort()
                    if context_blueprint_card then
                        context_blueprint_card:juice_up()
                    else
                        self:juice_up()
                    end
                    return true
                end }))
            playing_card_joker_effects({ _card })
        end
    end
}