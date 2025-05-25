---@param hand Card[]|table[]
--- Returns true if no ranks are next for another rank
local function all_skip_rank(hand)
    local ranks = {}
    for _, playing_card in ipairs(hand) do
        local id = playing_card:get_id()
        if id > 0 then
            for k, v in pairs(SMODS.Ranks) do
                if v.id == id then
                    table.insert(ranks, v)
                    break
                end
            end
        end
    end
    for i, rank in ipairs(ranks) do
        for j, other_rank in ipairs(ranks) do
            if i ~= j then
                if rank == other_rank then
                    return false
                end
                for _, next_rank in ipairs(rank.next) do
                    if SMODS.Ranks[next_rank] == other_rank then
                        return false
                    end
                end
            end
        end
    end
    return true
end

SMODS.PokerHand({
    key = "jog",
    mult = 6,
    chips = 30,
    l_mult = 3,
    l_chips = 10,
    visible = false,
    example = {
        { "C_T", true },
        { "D_8", true },
        { "D_6", true },
        { "S_4", true },
        { "H_2", true },
    },
    evaluate = function(parts, hand)
        if not G.GAME.hands["folly_jog"].visible then
            return {}
        end
        -- get straighs with skips enabled
        local straights =
            get_straight(hand, next(SMODS.find_card("j_four_fingers")) and 4 or 5, true)
        for i = #straights, 1, -1 do
            --keep if they all skip a rank
            if not all_skip_rank(straights[i]) then
                table.remove(straights, i)
            end
        end
        return straights
    end,
})
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
    folly_jog = true,
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
