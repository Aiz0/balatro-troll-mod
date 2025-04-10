SMODS.Joker({
    key = "apartment",
    config = {
        extra = 0,
    },
    cost = 10,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.hand then
            local temp_Chips, temp_ID = 15, 15
            local raised_card = nil
            for i = 1, #G.hand.cards do
                if temp_ID >= G.hand.cards[i].base.id and G.hand.cards[i].ability.effect ~= 'Stone Card' then
                    temp_Chips = G.hand.cards[i].base.nominal
                    temp_ID = G.hand.cards[i].base.id
                    raised_card = G.hand.cards[i]
                end
            end
            if raised_card == context.other_card then
                if context.other_card.debuff then
                    return {
                        message = localize('k_debuffed'),
                        colour = G.C.RED,
                        card = card
                    }
                else
                    card.ability.extra = card.ability.extra + temp_Chips
                    return {
                        message = "+" .. temp_Chips,
                        colour = G.C.CHIPS,
                        card = card
                    }
                end
            end
        end

        if context.joker_main then
            return {
                chips = card.ability.extra,
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "Apartment",
        text = {
            "This Joker gains",
            "Chips equal to the",
            "{C:attention}lowest{} ranked card",
            "held in hand",
            "{C:inactive}(Currently {C:chips}+#1# {C:inactive}Chips)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

SMODS.Joker({
    key = "house",
    rarity = 2,
    cost = 10,
    in_pool = function(self, args)
        return false
    end,
    calculate = function(self, card, context)
        if context.individual and context.cardarea == G.play then
            context.other_card.ability.perma_mult = (context.other_card.ability.perma_mult or 0) + 1

            return {
                extra = { message = localize('k_upgrade_ex'), colour = G.C.MULT },
                colour = G.C.MULT,
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "House",
        text = {
            "Every played {C:attention}card{}",
            "permanently gains",
            "{C:mult}+1{} Mult when scored",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra } }
    end,
})

function remove_weird_freaky_invisible_cards(card_table)
    for i, v in pairs(card_table) do
        v:remove()
    end
    card_table = {}
end

SMODS.Joker({
    key = "mansion",
    rarity = 3,
    cost = 10,
    config = {
        extra = {
            xmult_mod = 0.02,
            xmult = 1,
            marked_for_remove = {}
        }
    },
    in_pool = function(self, args)
        return false
    end,
    remove_from_deck = function(self, card, from_debuff)
        remove_weird_freaky_invisible_cards(card.ability.extra.marked_for_remove)
    end,
    calculate = function(self, card, context)
        if context.final_scoring_step and not context.blueprint then
            for k, v in ipairs(context.scoring_hand) do
                card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
                if v.base.nominal == 2 then
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            v:start_dissolve({ HEX("57ecab") }, nil, 1);
                            table.insert(card.ability.extra.marked_for_remove, v)
                            return true
                        end
                    }))
                else
                    G.E_MANAGER:add_event(Event({
                        trigger = 'after',
                        delay = 0.1,
                        func = function()
                            SMODS.modify_rank(v, -1)
                            v:juice_up()
                            return true
                        end
                    }))
                end
            end

            return {
                message = "Evil Billionaire Power",
                colour = G.C.RED,
                card = card
            }
        end

        if context.end_of_round and context.cardarea == G.jokers then
            remove_weird_freaky_invisible_cards(card.ability.extra.marked_for_remove)
        end

        if context.joker_main and card.ability.extra.xmult ~= 1 then
            return {
                xmult = card.ability.extra.xmult
            }
        end
    end,

    -- localization
    loc_txt = {
        name = "Mansion",
        text = {
            "Reduces rank of",
            "all {C:attention}scoring cards{}",
            "in played hand",
            "Gain {X:red,C:white}X#1#{} Mult",
            "per rank reduced",
            "{C:inactive}(Currently {X:red,C:white}X#2#{C:inactive} Mult)"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.xmult_mod,
            card.ability.extra.xmult,
        } }
    end,
})

SMODS.DrawStep {
    key = 'folly_debuff',
    order = 70,
    func = function(self)
        if self.folly_debuff then
            self.children.center:draw_shader('debuff', nil, self.ARGS.send_to_shader)
            if self.children.front and (self.ability.delayed or (self.ability.effect ~= 'Stone Card' and not self.config.center.replace_base_card)) then
                self.children.front:draw_shader('debuff', nil, self.ARGS.send_to_shader)
            end
        end
    end,
    conditions = { vortex = false, facing = 'front' },
}

SMODS.Sound({
    key = "house_bach",
    path = "house_bach.ogg"
})

local mod_prefix = SMODS.current_mod.prefix
SMODS.Joker({
    key = "dr_house",
    rarity = 4,
    cost = 10,
    config = {
        extra = {
            xmult = 2,
            redebuff = {}
        }
    },
    in_pool = function(self, args)
        return false
    end,
    remove_from_deck = function(self, card, from_debuff)
        if from_debuff then
            card:set_debuff(false)
        else
            for i, v in pairs(G.playing_cards) do
                SMODS.debuff_card(v, true, "house_md")
            end
            for i, v in pairs(G.jokers.cards) do
                SMODS.debuff_card(v, true, "house_md")
            end
            play_sound(mod_prefix.."_house_bach", 1, 1)
            G.E_MANAGER:add_event(Event({
                trigger = "before",
                delay = 2,
                func = function()
                    attention_text({
                        scale = 2,
                        text = "This Vexes Me",
                        hold = 60,
                        align = "cm",
                        offset = { x = 0, y = 0 },
                        major = G.play,
                    })
                    return true
                end,
            }))
        end
    end,
    calculate = function(self, card, context)
        if context.end_of_round then
            for i, v in pairs(G.deck.cards) do
                v.folly_debuff = nil
            end
            for i, v in pairs(card.ability.extra.redebuff) do
                SMODS.debuff_card(v, true, "house_md")
            end
        end
        
        if context.before then
            for i, v in pairs(context.scoring_hand) do
                if v.debuff then
                    if v.ability.debuff_sources and v.ability.debuff_sources["house_md"] then
                        SMODS.debuff_card(v, false, "house_md")
                        table.insert(card.ability.extra.redebuff, v)
                    end
                    v:set_debuff(false)
                    v.ability.x_mult = card.ability.extra.xmult
                    v.folly_debuff = true
                end
            end
        end

        if context.other_joker then
            if context.other_joker.debuff then
                if context.blueprint then
                    return {
                        xmult = card.ability.extra.xmult
                    }
                end
                local ret = context.other_joker:calculate_joker({
                    cardarea = context.cardarea,
                    full_hand = context.full_hand,
                    scoring_hand = context.scoring_hand,
                    scoring_name = context.scoring_name,
                    poker_hands = context.poker_hands,
                    joker_main = true });
                card:juice_up()
                ret.x_mult_mod = card.ability.extra.xmult
                ret.message_card = context.other_joker
                return ret
            end
        end
    end,

    -- localization
    loc_txt = {
        name = "Dr. House",
        text = {
            "{C:inactive}Debuffed {}cards still score.",
            "{C:inactive}Debuffed{} cards",
            "each give {X:mult,C:white}X#1#{} Mult",
            "{C:dark_edition}But watch out!"
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = {
            card.ability.extra.xmult,
        } }
    end,
})

return {
    key = "blueprint",
    calculate = function(self, card, context)
        if context.end_of_round and context.cardarea == G.jokers and not context.repetition then
            local other_joker = nil
            for i = 1, #G.jokers.cards do
                if G.jokers.cards[i] == card then other_joker = G.jokers.cards[i+1] end
            end
            
            sendInfoMessage(tostring(context), "Folly Jokers Debug")
            if other_joker then
                local suffix = "apartment"
                if other_joker.rarity == 2 then
                    suffix = "house"
                elseif other_joker.rarity == 3 then
                    suffix = "mansion"
                elseif other_joker.rarity == 4 then
                    suffix = "dr_house"
                end

                folly_utils.replace(card, folly_utils.prefix.joker..suffix)
            end
        end
    end
}
