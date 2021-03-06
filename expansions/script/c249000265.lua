--Catalyst of Flowing Evolution
function c249000265.initial_effect(c)
	--Special Summon
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(12538374,0))
	e1:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetCode(EVENT_PHASE+PHASE_STANDBY)
	e1:SetRange(LOCATION_GRAVE)
	e1:SetCountLimit(1,2490002651)
	e1:SetCost(c249000265.cost2)
	e1:SetTarget(c249000265.target2)
	e1:SetOperation(c249000265.operation2)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_XMATERIAL)
	e2:SetCode(EFFECT_CHANGE_TYPE)
	e2:SetValue(TYPE_MONSTER+TYPE_EFFECT+TYPE_XYZ)
	c:RegisterEffect(e2)
	--immune spell
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE)
	e3:SetCode(EFFECT_IMMUNE_EFFECT)
	e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetValue(c249000265.efilter)
	c:RegisterEffect(e3)
	--rank-up
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(1073)
	e5:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e5:SetType(EFFECT_TYPE_XMATERIAL+EFFECT_TYPE_IGNITION)
	e5:SetCountLimit(1,249000265)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(c249000265.condition)
	e5:SetCost(c249000265.cost)
	e5:SetTarget(c249000265.target)
	e5:SetOperation(c249000265.operation)
	c:RegisterEffect(e5)
end
function c249000265.costfilter2(c)
	return c:IsType(TYPE_TRAP) and c:IsDiscardable()
end
function c249000265.cost2(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000265.costfilter2,tp,LOCATION_HAND,0,1,e:GetHandler()) end
	Duel.DiscardHand(tp,c249000265.costfilter2,1,1,REASON_COST+REASON_DISCARD)
end
function c249000265.filter3(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c249000265.target2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_GRAVE) and chkc:IsControler(tp) and c249000265.filter3(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingTarget(c249000265.filter3,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,c249000265.filter3,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,1,0,0)
end
function c249000265.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and Duel.SpecialSummon(tc,0,tp,tp,false,false,POS_FACEUP)~=0 and c:IsRelateToEffect(e) then
		c:CancelToGrave()
		Duel.Overlay(tc,Group.FromCards(c))
	end
end
function c249000265.drcon(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp
end
function c249000265.drtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c249000265.drop(e,tp,eg,ep,ev,re,r,rp)
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end
function c249000265.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetOriginalAttribute()==ATTRIBUTE_WATER
end
function c249000265.costfilter(c)
	return c:IsSetCard(0x1D0) and c:IsAbleToRemoveAsCost()
end
function c249000265.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c249000265.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectMatchingCard(tp,c249000265.costfilter,tp,LOCATION_GRAVE+LOCATION_HAND,0,1,1,nil)
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function c249000265.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local c=e:GetHandler()
	if chk==0 then return Duel.GetLocationCountFromEx(tp,tp,c)>0 end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c249000265.operation(e,tp,eg,ep,ev,re,r,rp)
	if Duel.GetLocationCount(tp,LOCATION_MZONE)<0 then return end
	local tc=e:GetHandler()
	if tc:IsFacedown() or not tc:IsRelateToEffect(e) or tc:IsControler(1-tp) or tc:IsImmuneToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local ac=Duel.AnnounceCardFilter(tp,ATTRIBUTE_WATER,OPCODE_ISATTRIBUTE,TYPE_XYZ,OPCODE_ISTYPE,OPCODE_AND,249000265,OPCODE_ISCODE,OPCODE_OR)
	sc=Duel.CreateToken(tp,ac)
	while not (sc:IsType(TYPE_XYZ) and (sc:GetRank() == tc:GetRank()+2)
		and sc:IsAttribute(ATTRIBUTE_WATER) and sc:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,true,false))
	do
		ac=Duel.AnnounceCardFilter(tp,ATTRIBUTE_WATER,OPCODE_ISATTRIBUTE,TYPE_XYZ,OPCODE_ISTYPE,OPCODE_AND,249000265,OPCODE_ISCODE,OPCODE_OR)
		sc=Duel.CreateToken(tp,ac)
		if ac==249000265 then return end
	end
	Duel.SendtoDeck(sc,nil,0,REASON_RULE)
	if sc then
		local mg=tc:GetOverlayGroup()
		if mg:GetCount()~=0 then
			Duel.Overlay(sc,mg)
		end
		sc:SetMaterial(Group.FromCards(tc))
		Duel.Overlay(sc,Group.FromCards(tc))
		Duel.SpecialSummon(sc,SUMMON_TYPE_XYZ,tp,tp,true,true,POS_FACEUP)
		sc:CompleteProcedure()
	end
end
function c249000265.efilter(e,te)
	if e:GetHandler():GetOriginalAttribute()~=ATTRIBUTE_WATER then return false end
	return te:IsActiveType(TYPE_SPELL) and te:GetOwnerPlayer()~=e:GetHandlerPlayer()
end