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