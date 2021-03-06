@testset "Constructors of Basic Fairness Calc. Metrics" begin
    ft = job_fairtensor()
    # check all constructors
    m = TruePositive()
    @test m(ft) == truepositive(ft)
    m = TrueNegative()
    @test m(ft) == truenegative(ft)
    m = FalsePositive()
    @test m(ft) == falsepositive(ft)
    m = FalseNegative()
    @test m(ft) == falsenegative(ft)
    m = TruePositiveRate()
    @test m(ft) == tpr(ft) == truepositive_rate(ft)
    m = TrueNegativeRate()
    @test m(ft) == tnr(ft) == truenegative_rate(ft)
    m = FalsePositiveRate()
    @test m(ft) == fpr(ft) == falsepositive_rate(ft)
    m = FalseNegativeRate()
    @test m(ft) == fnr(ft) == falsenegative_rate(ft)
    m = FalseDiscoveryRate()
    @test m(ft) == fdr(ft) == falsediscovery_rate(ft)
    m = Precision()
    @test m(ft) == positive_predictive_value(ft)
    m = NPV()
    @test m(ft) == npv(ft)
    # check synonyms
    m = TPR()
    @test m(ft) == tpr(ft)
    m = TNR()
    @test m(ft) == tnr(ft)
    m = FPR()
    @test m(ft) == fpr(ft) == fallout(ft)
    m = FNR()
    @test m(ft) == fnr(ft) == miss_rate(ft)
    m = FDR()
    @test m(ft) == fdr(ft)
end

@testset "Values for Basic Fairness Calc. Metrics" begin
    ft = job_fairtensor()
    @test true_positive(ft) == 2
    @test truenegative(ft) == 1
    @test falsepositive(ft) == 3
    @test falsenegative(ft) == 4
    @test truepositive_rate(ft) ≈ 1/3
    @test truenegative_rate(ft) == 0.25
    @test falsepositive_rate(ft) == 0.75
    @test falsenegative_rate(ft) ≈ 2/3
    @test falsediscovery_rate(ft) == 0.4
    @test positive_predictive_value(ft) == 0.6
    @test negative_predictive_value(ft) == 0.2
end

@testset "Group Specific Calc. Metrics" begin
    ft = job_fairtensor()
    @test MLJFair._ftIdx(ft, "Education") == 2
    @test_throws ArgumentError MLJFair._ftIdx(ft, "ABCDE")
    @test true_positive(ft; grp=ft.labels[1]) == 2
    @test truenegative(ft; grp=ft.labels[2]) == 1
    @test falsepositive(ft; grp=ft.labels[3]) == 1
    @test falsenegative(ft; grp=ft.labels[1]) == 2
    @test truepositive_rate(ft; grp=ft.labels[1]) == 0.5
    @test truenegative_rate(ft; grp=ft.labels[2]) ≈ 1/3
    @test falsepositive_rate(ft; grp=ft.labels[2]) ≈ 2/3
    @test isnan(falsenegative_rate(ft; grp=ft.labels[2]))
    @test falsediscovery_rate(ft; grp=ft.labels[3]) == 0.0
    @test positive_predictive_value(ft; grp=ft.labels[3]) == 1.0
    @test negative_predictive_value(ft; grp=ft.labels[3]) == 0.0
end

@testset "Disparity" begin
    ft = job_fairtensor()
    M = [true_positive_rate, false_positive_rate, ppv]
    @test_throws ArgumentError disparity(M, ft)
    d = disparity(M, ft; refGrp="Education")
    @test names(d) == [:labels, :true_positive_rate_disparity, :false_positive_rate_disparity,
                        :positive_predictive_value_disparity]
    a = convert(Array, d[:, [2, 3, 4]])
    @test all(isnan.(a[:, 1])) && isnan(a[1, 2]) && a[[2, 3], 2]≈[1, 1.5] && a[:, 3]==[0, 1, 1]
end
