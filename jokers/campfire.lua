SMODS.Joker({
    key = "charcoal",
    config = {
        extra = {
            mult = -5,
        },
    },
    cost = -10,
    in_pool = function(self, args) return false end,
    calculate = function(self, card, context)
        if context.joker_main then return {
            mult = -5,
        } end
    end,

    -- localization
    loc_txt = {
        name = "Charcoal",
        text = {
            "You have to keep your campfire lit, idiot.",
            "{C:mult}#1#{} Mult",
        }
    },
    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.mult } }
    end,
})

return {
    key = "campfire",
    cost = 9,
    config = {
        extra = {
            xmult_mod = 0.25,
            xmult = 1.5,
        }
    },
    calculate = function(self, card, context)
        if context.selling_card and not (card == context.other_card) then -- selling adds fuel to the fire
            card.ability.extra.xmult = card.ability.extra.xmult + card.ability.extra.xmult_mod
        end
        if context.after then -- reduce xMult when a hand is scored
            card.ability.extra.xmult = card.ability.extra.xmult - card.ability.extra.xmult_mod
            if card.ability.extra.xmult <= 0 then
                folly_ulits:replace("charcoal") -- get charcoaled idiot
            end
        end
        if context.joker_main then
            if not card.ability.extra.xmult == 1 then -- just a check for if the card does anything.
                return {
                    xmult = card.ability.extra.xmult,
                }
            end
        end
    end,

    loc_vars = function(self, info_queue, card)
        return { vars = { card.ability.extra.xmult_mod, card.ability.extra.xmult } }
    end,
    -- localization
    --loc_txt = {
    --    name = "Campfire",
    --    text = {
    --        "This Joker gains {X:mult,C:white}X#1#{} Mult",
    --        "for each card sold and loses {X:mult,C:white}X#1#{} Mult",
    --        "for each hand played",
    --        "{C:inactive}(Currently {X:mult,C:white}X#2#{C:inactive} Mult)"
    --    }
    --},

}
