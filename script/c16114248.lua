--ペア・サイクロイド
function c16114248.initial_effect(c)
	c:EnableReviveLimit()
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(c16114248.fscon)
	e1:SetOperation(c16114248.fsop)
	c:RegisterEffect(e1)
	--direct attack
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetCode(EFFECT_DIRECT_ATTACK)
	c:RegisterEffect(e2)
end
function c16114248.filter(c,fc)
	return c:IsRace(RACE_MACHINE) and c:IsCanBeFusionMaterial(fc)
end
function c16114248.spfilter(c,mg,chkf)
	return (chkf==PLAYER_NONE or aux.FConditionCheckF(c,chkf)) and mg:IsExists(c16114248.spfilter2,1,c,c)
end
function c16114248.spfilter2(c,mc)
	return c:IsFusionCode(mc:GetFusionCode())
end
function c16114248.fscon(e,g,gc,chkfnf)
	if g==nil then return true end
	local chkf=bit.band(chkfnf,0xff)
	local mg=g:Filter(c16114248.filter,gc,e:GetHandler())
	if gc then
		if chkf~=PLAYER_NONE and not aux.FConditionCheckF(gc,chkf) then
			mg=mg:Filter(aux.FConditionCheckF,nil,chkf)
		end
		return c16114248.filter(gc,e:GetHandler()) and c16114248.spfilter(gc,mg) end
	return mg:IsExists(c16114248.spfilter,1,nil,mg,chkf)
end
function c16114248.fsop(e,tp,eg,ep,ev,re,r,rp,gc,chkfnf)
	local mg=eg:Filter(c16114248.filter,gc,e:GetHandler())
	local chkf=bit.band(chkfnf,0xff)
	local g1=nil
	local mc=gc
	if not gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		g1=mg:FilterSelect(tp,c16114248.spfilter,1,1,nil,mg,chkf)
		mc=g1:GetFirst()
	elseif chkf~=PLAYER_NONE and not aux.FConditionCheckF(gc,chkf) then
		mg=mg:Filter(aux.FConditionCheckF,nil,chkf)
	end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=mg:FilterSelect(tp,c16114248.spfilter2,1,1,mc,mc)
	if g1 then g2:Merge(g1) end
	Duel.SetFusionMaterial(g2)
end
