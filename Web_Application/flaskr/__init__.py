from flask import Flask, render_template

def home_page():
    return render_template("index.html")

app = Flask(__name__, template_folder='templates/blog/')

def create_app():
    app.add_url_rule("/", view_func=home_page)
    return app

@app.route("/<htmlName>")
def index(htmlName):
    if htmlName == 'index':
        app.add_url_rule("/index", view_func=home_page)
        return app
    render_template("{}.html".format(htmlName), htmlName=htmlName)

if __name__ == "__main__":
    app = create_app()
    port = app.config.get("PORT", 5000)
    app.run(host="0.0.0.0", debug=True , port=port)
