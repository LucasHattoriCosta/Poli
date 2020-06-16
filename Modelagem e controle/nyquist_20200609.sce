s = %s
gh = syslin('c',1,s*(s+1)*(s+0.5))
[margem_fase, omega_pi] = p_margin(gh)
[margem_ganho, omega_ganho] = g_margin(gh)

scf(0)
show_margins(gh,'nyquist')

scf(1)
nyquist(gh)

scf(2)
show_margins(gh, 0.01, 100)


scf(3)
bode(gh)

//disp(margem_fase,'Margem de fase')
//disp(omega_ganho,'omega_ganho')
//disp(margem_ganho,'Margem de margem_ganho')
//disp(omega_pi,'omega_pi')
