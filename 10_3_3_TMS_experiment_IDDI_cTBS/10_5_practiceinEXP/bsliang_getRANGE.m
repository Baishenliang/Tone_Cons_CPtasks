function RANGE=bsliang_getRANGE(XE1,XC,XE2)
if abs(XC-XE1)<=abs(XC-XE2)
    RANGE=[XE1,2*XC-XE1];
elseif  abs(XC-XE1)>abs(XC-XE2)
    RANGE=[2*XC-XE2,XE2];
end