### A Pluto.jl notebook ###
# v0.17.5

using Markdown
using InteractiveUtils

# This Pluto notebook uses @bind for interactivity. When running this notebook outside of Pluto, the following 'mock version' of @bind gives bound variables a default value (instead of an error).
macro bind(def, element)
    quote
        local iv = try Base.loaded_modules[Base.PkgId(Base.UUID("6e696c72-6542-2067-7265-42206c756150"), "AbstractPlutoDingetjes")].Bonds.initial_value catch; b -> missing; end
        local el = $(esc(element))
        global $(esc(def)) = Core.applicable(Base.get, el) ? Base.get(el) : iv(el)
        el
    end
end

# ╔═╡ 705ea590-6c05-11ec-00b5-578d2b63e1ea
begin
	using Pkg
	Pkg.activate("..")
	using Plots
	using PlutoUI
end

# ╔═╡ 53b09e7b-f283-4ff9-a08a-36bed86927df
PK(t, Dm, Vd, F, ka, ke, Td) = F*Dm/Vd*ka/(ke-ka)*((1-exp((trunc(t/Td)+1)*-ka*Td))/(1-exp(-ka*Td))*(exp(-ka*(t%Td))-((1-exp((trunc(t/Td)+1)*-ke*Td))/(1-exp(-ke*Td))*(exp(-ke*(t%Td))))));

# ╔═╡ 85453411-345e-402f-b121-d190d0f969da
md"# Pharmacokinetics Demonstration"

# ╔═╡ fc977e05-da1a-4344-b45d-f05a4fc53f4e
md"One compartment model of repeted administration pharmacokinetics"

# ╔═╡ 247a19de-e2a6-4ac1-aafe-9c0895091095
Dm = 40

# ╔═╡ 441b62b1-4032-4f87-8a65-fa57ff607474
Vd = 1.0

# ╔═╡ 7223c778-8742-4271-97bc-b599d2a946f6
F = 1.0

# ╔═╡ 3910d7df-93b4-491a-a3cf-2b8c48d4c8dc
tspan = 0:1:240

# ╔═╡ f76fe69b-6e19-4805-9657-1aafef3b3e08
@bind ke Slider(0.01:0.01:1; default = 0.1)

# ╔═╡ 5c2beb78-40d1-4d47-9287-c818b7d3f2dc
"ke: $(ke)"

# ╔═╡ 00f902cd-3675-4488-a564-521bab946fda
@bind ka Slider(1:1:100; default = 50)

# ╔═╡ edb3043c-262f-4473-87cc-e021507c6098
"ka: $(ka)"

# ╔═╡ 991427cf-15f1-49b3-8cdf-4aae184cd224
@bind Td Slider(1:1:10; default = 4)

# ╔═╡ 5f9c2fa0-ee2b-485d-962f-230231baef1f
"Td: $(Td)"

# ╔═╡ 8db8d8c3-a9d5-4078-937e-74bdc14fe577
y = [PK(i, Dm, Vd, F, ka, ke, Td) for i in tspan];

# ╔═╡ 6b607e5d-2f77-4440-91d0-09250a52d059
@bind tox_function Select(["Simple", "Mitochondrial"])

# ╔═╡ f9279a7d-c7d3-4c05-94ef-abc20dda087c
begin
	if tox_function == "Simple"
		low = 0.5*maximum(y)
		high = 1.2*maximum(y)
		md"Toxicity Threshold $(@bind Tox Slider(low:(high-low)/100:high))"
	elseif tox_function == "Mitochondrial"
		low = 0.5*maximum(y)
		high = 1.2*maximum(y)
		@bind values PlutoUI.combine() do Child
			md"""
			Starting Toxicity: $(Child(Slider(low:(high-low)/100:high, default = 132)))
			
			Onset Time: $(Child(Slider(tspan[1]:4:tspan[end], default = 56)))
			
			Slope: $(Child(Slider(0:0.1:1, default = 0.3)))
			"""
		end
	end
end

# ╔═╡ fe58d31d-0317-441a-85d4-267d31024b0a
begin 
	function plotting_tox(tox_function)
		if tox_function == "Simple"
			plot!([tspan[1], tspan[end]], [Tox, Tox], line = :dash, color = :red, legend = false)
		elseif tox_function == "Mitochondrial"
			y(x) = values[1]-values[3]*(x-values[2])
			plot!([tspan[1],values[2]], [values[1],values[1]], line = :dash, color = :red)
			plot!(values[2]:tspan[end], x -> values[1]-values[3]*(x-values[2]), line = :dash, color = :red, legend = false)
		end
	end
end;

# ╔═╡ d9e1d4da-100c-463e-9b79-8983119ce76c
begin
plot(tspan, y)
plotting_tox(tox_function)
end

# ╔═╡ Cell order:
# ╟─705ea590-6c05-11ec-00b5-578d2b63e1ea
# ╟─53b09e7b-f283-4ff9-a08a-36bed86927df
# ╟─85453411-345e-402f-b121-d190d0f969da
# ╟─fc977e05-da1a-4344-b45d-f05a4fc53f4e
# ╠═247a19de-e2a6-4ac1-aafe-9c0895091095
# ╠═441b62b1-4032-4f87-8a65-fa57ff607474
# ╠═7223c778-8742-4271-97bc-b599d2a946f6
# ╠═3910d7df-93b4-491a-a3cf-2b8c48d4c8dc
# ╟─5c2beb78-40d1-4d47-9287-c818b7d3f2dc
# ╟─f76fe69b-6e19-4805-9657-1aafef3b3e08
# ╟─edb3043c-262f-4473-87cc-e021507c6098
# ╟─00f902cd-3675-4488-a564-521bab946fda
# ╟─5f9c2fa0-ee2b-485d-962f-230231baef1f
# ╟─991427cf-15f1-49b3-8cdf-4aae184cd224
# ╟─8db8d8c3-a9d5-4078-937e-74bdc14fe577
# ╠═6b607e5d-2f77-4440-91d0-09250a52d059
# ╟─f9279a7d-c7d3-4c05-94ef-abc20dda087c
# ╟─fe58d31d-0317-441a-85d4-267d31024b0a
# ╟─d9e1d4da-100c-463e-9b79-8983119ce76c
