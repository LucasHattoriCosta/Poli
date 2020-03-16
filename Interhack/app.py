from flask import *

app = Flask(__name__)

@app.route('/', methods=['GET','POST'])
def hello_world():
    return render_template('actual.html')

@app.route('/login', methods=['POST', 'GET'])
def login():
    error = None
    if request.method == 'POST':
        nome = request.form['nome']
        peso = request.form['peso']
        
    else:   
        error = 'Invalid username/password'
# the code below is executed if the request method
# was GET or the credentials were invalid
        return render_template('actual2.html', error=error)

@app.route('/result', methods=['GET','POST'])
def handle_data():
    if request.method == 'POST':
        nome = request.form['nome']
        peso = request.form['peso']
    return render_template('actual2.html')

if __name__ == '__main__':
    app.run()