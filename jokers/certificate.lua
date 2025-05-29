--                      2, 3, 4, 5, 6, 7, 8, 9, 10,J, Q, K, A
local rank_approval = { 2, 2, 2, 2, 2, 2, 1, 1, 2, 3, 3, 4, 2 }
local suit_approval = { Spades = 1, Clubs = 2, Diamonds = 3, Hearts = 4 }
local enhancement_approval = { ["Bonus"] = 1, ["Mult"] = 2, ["Wild Card"] = 1, ["Glass Card"] = 4, ["Steel Card"] = 3, ["Stone Card"] = 1, ["Gold Card"] = 3, ["Lucky Card"] = 3 }
local editions_approval = { ["foil"] = 2, ["holo"] = 3, ["polychrome"] = 4, ["negative"] = 4 }

SMODS.Seal({
    key = "approval",
    atlas = "folly_seals",
    pos = { x = 0, y = 0 },
    calculate = function(self, card, context)
        if context.main_scoring and context.cardarea == G.play then
            local approval = 1
            if card.base.id <= #rank_approval then
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
    calculate = function(self, card, context)

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