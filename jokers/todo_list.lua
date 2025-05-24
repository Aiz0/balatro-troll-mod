-- SMODS.PokerHand({
--     key = "jog",
--     mult = 4,
--     chips = 30,
--     l_mult = 4,
--     l_chips = 4,
-- })
--
SMODS.PokerHand({
    key = "karate",
    mult = 4,
    chips = 30,
    l_mult = 3,
    l_chips = 10,
    visible = false,
    example = {
        { "H_K", true },
        { "D_A", true },
        { "S_7", true },
        { "S_2", true },
        { "C_8", true },
    },
    evaluate = function(parts, hand)
        local ret = {}
        if #hand < 5 or not G.GAME.hands["folly_karate"].visible then
            return {}
        end

        local karate = { 13, 14, 7, 2, 8 }
        for i = 1, #hand do
            for j = 1, #karate do
                if hand[i]:get_id() == karate[j] then
                    table.insert(ret, hand[i])
                    table.remove(karate, j)
                    break
                end
            end
        end
        if #ret == 5 then
            return { ret }
        end
        return {}
    end,
})

SMODS.PokerHand({
    key = "ruminate",
    mult = 4,
    chips = 30,
    l_mult = 3,
    l_chips = 10,
    visible = false,
    example = {
        { "S_K", true, enhancement = "m_glass" },
        { "S_9", true, enhancement = "m_glass" },
        { "D_9", true, enhancement = "m_glass" },
        { "H_6", true, enhancement = "m_glass" },
        { "D_3", true, enhancement = "m_glass" },
    },
    evaluate = function(parts, hand)
        local ret = {}
        if #hand < 5 or not G.GAME.hands["folly_ruminate"].visible then
            return {}
        end
        for i = 1, #hand do
            if SMODS.has_enhancement(hand[i], "m_glass") then
                table.insert(ret, hand[i])
            end
        end
        if #ret == 5 then
            return { ret }
        end
        return {}
    end,
})

local to_do_list_extra_poker_hands = {
    folly_ruminate = true,
    folly_karate = true,
}

return {
    key = "todo_list",
    calculate = function(self, card, context)
        if
            context.end_of_round
            and not context.individual
            and not context.repetition
            and not context.blueprint
        then
            local _poker_hands = {}
            for k, v in pairs(G.GAME.hands) do
                if
                    (to_do_list_extra_poker_hands[k] or v.visible)
                    and k ~= card.ability.to_do_poker_hand
                then
                    table.insert(_poker_hands, k)
                end
            end
            card.ability.to_do_poker_hand = pseudorandom_element(_poker_hands, pseudoseed("to_do"))
            if not G.GAME.hands[card.ability.to_do_poker_hand].visible then
                folly_utils.log.Info("henlo")
                G.GAME.hands[card.ability.to_do_poker_hand].visible = true
            end
            return {
                message = localize("k_reset"),
            }
        end
    end,
}
