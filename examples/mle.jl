using JuMP

# Use nonlinear optimization to compute the maximum likelihood estimate (MLE)
# of the parameters of a normal distribution
# aka the sample mean and variance

n = 1000
data = rand(n)

m = Model()

@defVar(m, μ)
@defVar(m, σ >= 0.0)

# provide starting points -- this is needed
setValue(μ, 0.0)
setValue(σ, 1.0)

@setNLObjective(m, Max, (n/2)*log(1/(2π*σ^2))-sum{(data[i]-μ)^2, i=1:n}/(2σ^2))

solve(m)

println("μ = ", getValue(μ))
println("mean(data) = ", mean(data))
println("σ^2 = ", getValue(σ)^2)
println("var(data) = ", var(data))
println("MLE objective: ", getObjectiveValue(m))

# constrained MLE?
@addNLConstraint(m, μ == σ^2)

solve(m)
println("\nWith constraint μ == σ^2:")
println("μ = ", getValue(μ))
println("σ^2 = ", getValue(σ)^2)

println("Constrained MLE objective: ", getObjectiveValue(m))



