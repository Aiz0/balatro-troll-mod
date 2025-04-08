return {
    key = "shoot_the_moon",
    calculate = function(self, card, context)
        if context.setting_blind and not context.blueprint and not card.getting_sliced then
            if next(SMODS.find_card("j_to_the_moon")) or next(SMODS.find_card("j_rocket")) then
                for _, playing_card in ipairs(G.playing_cards) do
                    if
                        not (
                            playing_card:is_suit("Hearts")
                            or (playing_card:is_suit("Spades") and playing_card:get_id() == 12)
                        )
                    then
                        playing_card:start_dissolve()
                    end
                end
                return { message = localize("k_folly_shoot_the_moon") }
            end
        end
    end,
}
