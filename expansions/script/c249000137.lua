--Spell-Disciple Arcane Delver
function c249000137.initial_effect(c)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(10875327,0))
	e1:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_LEAVE_FIELD)
	e1:SetCountLimit(1,2490001371)
	e1:SetCondition(c249000137.spcon)
	e1:SetTarget(c249000137.sptg)
	e1:SetOperation(c249000137.spop)
	c:RegisterEffect(e1)
	--ATK up
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(36733451,0))
	e2:SetCategory(CATEGORY_ATKCHANGE)
	e2:SetType(EFFECT_TYPE_IGNITION)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCountLimit(1)
	e2:SetTarget(c249000137.target2)
	e2:SetOperation(c249000137.operation2)
	c:RegisterEffect(e2)
end
function c249000137.spcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsPreviousPosition(POS_FACEUP) and rp~=tp and not c:IsLocation(LOCATION_DECK)
end
function c249000137.spfilter(c,e,tp)
	return c:GetLevel()==4 and c:IsRace(RACE_SPELLCASTER) and c:IsSetCard(0x1D9) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000137.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c249000137.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK+LOCATION_HAND)
end
function c249000137.spop(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectMatchingCard(tp,c249000137.spfilter,tp,LOCATION_DECK+LOCATION_HAND,0,1,1,nil,e,tp)
	local tc=g:GetFirst()
	if tc then
		Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)
	end
end
function c249000137.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDiscardDeck(tp,1) end
	Duel.SetOperationInfo(0,CATEGORY_DECKDES,nil,0,tp,1)
end
function c249000137.operation2(e,tp,eg,ep,ev,re,r,rp,c)
	local c=e:GetHandler()
	Duel.DiscardDeck(tp,1,REASON_EFFECT)
	local g=Duel.GetOperatedGroup()
	local tc=g:GetFirst()
	if tc then
		if tc:GetLevel() > 0 and c:IsFaceup() and c:IsRelateToEffect(e) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
			e1:SetValue(tc:GetLevel() * 200)
			c:RegisterEffect(e1)
	elseif (tc:GetType()==TYPE_SPELL or tc:GetType()==TYPE_SPELL+TYPE_QUICKPLAY) then
			local ae=tc:GetActivateEffect()
			if tc:GetLocation()==LOCATION_GRAVE and ae and not (tc:GetType()==TYPE_SPELL+TYPE_QUICKPLAY and ae:GetCode()~=EVENT_FREE_CHAIN) then
				local e1=Effect.CreateEffect(tc)
				e1:SetDescription(ae:GetDescription())
				e1:SetType(EFFECT_TYPE_IGNITION)
				e1:SetCountLimit(1)
				e1:SetRange(LOCATION_GRAVE)
				e1:SetReset(RESET_EVENT+0x2fe0000+RESET_PHASE+PHASE_END+RESET_SELF_TURN,2)
				e1:SetCondition(c249000137.spellcon)
				e1:SetTarget(c249000137.spelltg)
				e1:SetOperation(c249000137.spellop)
				tc:RegisterEffect(e1)
			end
		end
	end
end
function c249000137.spellcon(e,tp,eg,ep,ev,re,r,rp,chk)
	return e:GetHandler():GetTurnID()~=Duel.GetTurnCount()
end
function c249000137.spelltg(e,tp,eg,ep,ev,re,r,rp,chk)
	local ae=e:GetHandler():GetActivateEffect()
	local ftg=ae:GetTarget()
	if chk==0 then
		return not ftg or ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
	if ae:IsHasProperty(EFFECT_FLAG_CARD_TARGET) then
		e:SetProperty(EFFECT_FLAG_CARD_TARGET)
	else e:SetProperty(0) end
	if ftg then
		ftg(e,tp,eg,ep,ev,re,r,rp,chk)
	end
end
function c249000137.spellop(e,tp,eg,ep,ev,re,r,rp)
	local ae=e:GetHandler():GetActivateEffect()
	local fop=ae:GetOperation()
	fop(e,tp,eg,ep,ev,re,r,rp)
end