@testset "Equalized Odds Postprocessing" begin
	X, y, _ = @load_toydata;
	model = ConstantClassifier()
	wrappedModel = EqOddsWrapper(model; grp=:Sex)
	mach = machine(wrappedModel, X, y)
	fit!(mach)
	ŷ = predict(mach, X[6:10, :])
	@test all(ŷ .== 1)
	@test length(ŷ)==5
	# TODO:test the fitresult of machine
end
