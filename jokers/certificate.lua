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

SMODS.Seal({
    key = "spheal",
    atlas = "folly_seals",
    pos = { x = 1, y = 0 },
    badge_colour = HEX("8c9eff"),
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local card_index
            for i = 1, #G.play.cards do
                if G.play.cards[i] == card then
                    card_index = i
                    break
                end
            end
            local ret = {}
            local juice_targets = {}
            context.extra_enhancement = true
            if card_index - 1 ~= 0 then
                local left_card = G.play.cards[card_index - 1];
                local left = eval_card(left_card, context)
                if left.playing_card then
                    ret.chips = left.playing_card.chips or nil
                    ret.mult = left.playing_card.mult or nil
                    ret.x_mult = left.playing_card.x_mult or nil
                    ret.p_dollars = left.playing_card.p_dollars or nil
                    ret.x_chips = left.playing_card.x_chips or nil
                    table.insert(juice_targets, function()
                        SMODS.calculate_effect(left.playing_card, left_card, false)
                    end)
                end
            end
            if card_index + 1 <= #G.play.cards then
                local right_card = G.play.cards[card_index + 1]
                local right = eval_card(right_card, context)
                if right.playing_card then
                    if ret.chips
                    then ret.chips = ret.chips + (right.playing_card.chips or 0)
                    else ret.chips = right.playing_card.chips or nil end
                    if ret.mult
                    then ret.mult = ret.mult + (right.playing_card.mult or 0)
                    else ret.mult = right.playing_card.mult or nil end
                    if ret.x_mult
                    then ret.x_mult = ret.x_mult + (right.playing_card.x_mult or 0)
                    else ret.x_mult = right.playing_card.x_mult or nil end
                    if ret.p_dollars
                    then ret.p_dollars = ret.p_dollars + (right.playing_card.p_dollars or 0)
                    else ret.p_dollars = right.playing_card.p_dollars or nil end
                    if ret.x_chips
                    then ret.x_chips = ret.x_chips + (right.playing_card.x_chips or 0)
                    else ret.x_chips = right.playing_card.x_chips or nil end
                    table.insert(juice_targets, function()
                        SMODS.calculate_effect(right.playing_card, right_card, false)
                    end)
                end
            end
            context.extra_enhancement = nil
            ret.func = function()
                for i, v in pairs(juice_targets) do
                    v()
                end
            end
            ret.message = localize("k_folly_spheal")
            ret.colour = G.C.BLUE
            ret.remove_default_message = true
            return ret
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

SMODS.Seal({
    key = "glass",
    atlas = "folly_seals",
    pos = { x = 2, y = 0 },
    calculate = function(self, card, context)

    end
})

SMODS.Seal({
    key = "navy",
    atlas = "folly_seals",
    pos = { x = 3, y = 0 },
    calculate = function(self, card, context)

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