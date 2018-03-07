function FA = calculate_FA(x,y);

ellipse_t = fit_ellipse(x,y);

mu1 = mean([ellipse_t.a,ellipse_t.b]);
mu2 = var([ellipse_t.a,ellipse_t.b]);

FA = sqrt((3*mu2)/(2*((mu1^2)+mu2)));

end