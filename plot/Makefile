venv:
	python3 -m venv venv
	venv/bin/pip install -r requirements.txt

fig1:
	venv/bin/python fig1.py ../data/client.out ../data/fig1-small-matrix.log

fig1-100000:
	venv/bin/python fig1.py ../data/fig1-100000-matrix-client.out ../data/fig1-100000-matrix-server.log

fig1-2000:
	venv/bin/python fig1.py ../data/fig1-client-2000.out ../data/fig1-2000-matrix-server.log

fig1-1000-20:
	venv/bin/python fig1.py ../data/fig1-client-1000-20.out ../data/fig1-1000-20-server.log

fig1-2000-20:
	venv/bin/python fig1.py ../data/fig1-client-2000-20.out ../data/fig1-2000-20-server.log

fig1-2000-20-delay50ms:
	venv/bin/python fig1.py ../data/fig1-client-delay50ms.out ../data/fig1-2000-20-server-delay50ms.log

fig2-1000-20-delay50ms:
	venv/bin/python fig1.py ../data/fig2-client.out ../data/fig2-1000-20-server.log

fig2-2000-20-delay50ms:
	venv/bin/python fig1.py ../data/fig2-client-2000-20.out ../data/fig2-2000-20-server.log

fig2-2000-20-delay50ms-weighted:
	venv/bin/python fig1.py ../data/fig2-2000-20-weighted5050/fig2-client.out ../data/fig2-2000-20-weighted5050/server.log

fig2-2000-20-delay50ms-weighted-991:
	venv/bin/python fig1.py ../data/fig2-2000-20-weighted991/fig2-client.out ../data/fig2-2000-20-weighted991/server.log

fig2-2000-20-delay50ms-weighted-2048:
	venv/bin/python fig1.py ../data/fig2-2000-20-weighted20481024/fig2-client.out ../data/fig2-2000-20-weighted20481024/server.log


fig3-2000-20-2048-1024-idle:
	venv/bin/python fig1.py ../data/fig3-2000-20-2048-1024-idle/client-fig3.out ../data/fig3-2000-20-2048-1024-idle/server.log

fig2-2000-20-2048-1024-rerun:
	venv/bin/python fig1.py ../data/fig2-2000-20-2048-1024-rerun/client-fig3.out ../data/fig2-2000-20-2048-1024-rerun/server.log

fig3-2000-20-nocgroup-idle:
	venv/bin/python fig1.py ../data/fig3-2000-20-nocgroup-idle/client-fig3.out ../data/fig3-2000-20-nocgroup-idle/server.log


# fig1-new:
# 	venv/bin/python fig1-new.py ../data/fig1-new/client-1fig1.out ../data/fig1-new/server.log ../data/fig1-new/mm-1.out

FIG_EXT = scale
fig1-new:
	venv/bin/python fig-mult.py ../data/fig1-$(FIG_EXT)/server.log ../data/fig1-$(FIG_EXT)/mm-1.out ../data/fig1-$(FIG_EXT)/client-*.out

# fig2-new:
# 	venv/bin/python fig1-new.py ../data/fig2-new/client-1fig2.out ../data/fig2-new/server.log ../data/fig2-new/mm-1.out

fig2-new:
	venv/bin/python fig-mult.py ../data/fig2-$(FIG_EXT)/server.log ../data/fig2-$(FIG_EXT)/mm-1.out ../data/fig2-$(FIG_EXT)/client-*.out

# fig2b-new:
# 	venv/bin/python fig1-new.py ../data/fig2b-new/client-1fig2b.out ../data/fig2b-new/server.log ../data/fig2b-new/mm-1.out

fig2b-new:
	venv/bin/python fig-mult.py ../data/fig2b-$(FIG_EXT)/server.log ../data/fig2b-$(FIG_EXT)/mm-1.out ../data/fig2b-$(FIG_EXT)/client-*.out

fig1r:
	venv/bin/python fig-mult.py  ../data/fig1r/server.out ../data/fig1r/mm-1.out ../data/fig1r/client-*.out

fig4:
	venv/bin/python fig-mult.py ../data/fig4-$(FIG_EXT)/server.out ../data/fig4-$(FIG_EXT)/mm-1.out ../data/fig4-$(FIG_EXT)/client-*.out 

fig3:
	venv/bin/python fig-mult.py ../data/fig3-$(FIG_EXT)/server.out ../data/fig3-$(FIG_EXT)/mm-1.out ../data/fig3-$(FIG_EXT)/client-*.out 

fig2r:
	venv/bin/python fig-mult.py ../data/fig2r/server.out ../data/fig2r/mm-1.out ../data/fig2r/client-*.out 

fig3b:
	venv/bin/python fig-mult.py ../data/fig3b-$(FIG_EXT)/server.out ../data/fig3b-$(FIG_EXT)/mm-1.out ../data/fig3b-$(FIG_EXT)/client-*.out 

fig1rnm:
	venv/bin/python fig-mult.py ../data/fig1rnm/server.out ../data/fig1rnm/mm-1.out ../data/fig1rnm/client-*.out 
