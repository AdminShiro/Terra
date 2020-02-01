 --Created and coded by Rising Phoenix
function c100000919.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c100000919.targetd)
	e1:SetOperation(c100000919.activated)
	c:RegisterEffect(e1)
	--pierce
		local e7=Effect.CreateEffect(c)
	e7:SetDescription(aux.Stringid(100000919,1))
	e7:SetCategory(CATEGORY_ATKCHANGE)
	e7:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e7:SetRange(LOCATION_FZONE)
	e7:SetCode(EVENT_SPSUMMON_SUCCESS)
	e7:SetCondition(c100000919.condition2)
	e7:SetTargetRange(LOCATION_MZONE,0)
	e7:SetOperation(c100000919.operation2)
	e7:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e7)
	local e8=Effect.CreateEffect(c)
	e8:SetDescription(aux.Stringid(100000919,1))
	e8:SetCategory(CATEGORY_ATKCHANGE)
	e8:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e8:SetRange(LOCATION_FZONE)
	e8:SetCode(EVENT_SUMMON_SUCCESS)
	e8:SetCondition(c100000919.condition2)
	e8:SetTargetRange(LOCATION_MZONE,0)
	e8:SetOperation(c100000919.operation2)
	e8:SetProperty(EFFECT_FLAG_DELAY)
	c:RegisterEffect(e8)
		local e9=Effect.CreateEffect(c)
	e9:SetDescription(aux.Stringid(100000919,1))
	e9:SetCategory(CATEGORY_ATKCHANGE)
	e9:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e9:SetRange(LOCATION_FZONE)
	e9:SetProperty(EFFECT_FLAG_DELAY)
	e9:SetCode(EVENT_FLIP_SUMMON_SUCCESS)
	e9:SetCondition(c100000919.condition2)
	e9:SetTargetRange(LOCATION_MZONE,0)
	e9:SetOperation(c100000919.operation2)
	c:RegisterEffect(e9)
end
function c100000919.condition2(e,tp,eg,ep,ev,re,r,rp)
	return eg:IsExists(c100000919.cfilter,1,nil,tp)
end
function c100000919.cfilter(c,tp)
	return c:IsSetCard(0x75D) and c:IsFaceup()
end
function c100000919.operation2(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
		if not c:IsRelateToEffect(e) then return end
	local g=Duel.GetMatchingGroup(c100000919.cfilter,tp,LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_SINGLE)
		e3:SetCode(EFFECT_UPDATE_ATTACK)
		e3:SetReset(RESET_EVENT+0x1fe0000)
		e3:SetValue(500)
		tc:RegisterEffect(e3)
		tc=g:GetNext()
	end
end
function c100000919.targetd(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsPlayerCanDraw(tp,1) end
	Duel.SetTargetPlayer(tp)
	Duel.SetTargetParam(1)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c100000919.activated(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) then return end
	local p,d=Duel.GetChainInfo(0,CHAININFO_TARGET_PLAYER,CHAININFO_TARGET_PARAM)
	Duel.Draw(p,d,REASON_EFFECT)
end