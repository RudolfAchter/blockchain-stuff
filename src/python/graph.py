# From https://plotly.com/python/line-charts/
import plotly.express as px

df = px.data.gapminder().query("continent=='Oceania'")
fig = px.line(df, x="year", y="lifeExp", color='country')
# fig.show()

# Output html that you can copy paste
fig.to_html(full_html=False, include_plotlyjs='cdn')
# Saves a html doc that you can copy paste
fig.write_html("output.html", full_html=False, include_plotlyjs='cdn')
