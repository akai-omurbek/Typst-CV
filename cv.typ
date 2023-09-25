#set page(
  paper: "a4",
  margin: (
    top: 0.5cm,
    rest: 1cm
  )
)
#set par(justify: true)
#set text(
  font: "Arial",
  size: 12pt,
  hyphenate:false
)

/* SHOW RULES | LABELS | ETC */
#show <cv>: it => [
  #set align(center + horizon)
  #set text(size: 16pt)
  #upper(it)
  ]

#show <name>: it => [
  #set align(center + horizon)
  #set text(size: 20pt)
  #underline(offset: 5pt, upper(it))
  ]

#show heading.where(level:2): it => [
  #set align(center)
  #set text(size: 12pt)
  #upper(it.body)
  ]

/* FUNCS AND VARIABLES = FUNCS AND VARIABLES = FUNCS AND VARIABLES */

#let color1 = luma(230)

#let data = yaml("cv_info.yml")

#let myblock(text, radius: {0pt}, under: false, height: auto) = {
  block(
    width: 100%,
    height: height,
    fill: color1,
    inset: 6pt,
    spacing: 0pt,
    above: 4pt,
    below: 4pt,
    radius: radius,
    text +
    if under {
      line(
        length: 100%,
        stroke: 1pt,
      )
      }
    )
} 


#let iconlink(img,url) = {
stack(dir: ltr,spacing: 6pt,
  box(
    height: 1.5em,
    inset: 0pt,
    outset: 0pt,
    image("media/" + img)
  ), align(left + horizon, text(size:11pt, link(url) ) )
)
}

#let workitem(inf) = {myblock(
  grid(
    columns: (35%,65%),
    gutter: 2pt,
      [ *#inf.at("dates")* #linebreak() _#inf.at("addr")_],
      align(right, [ *#inf.at("pos")* \
      _#inf.at("employer")_ ])
  ) + pad(top: 2pt,
    [#for i in inf.at("notes") {
    list(marker: sym.arrow.r.curve, i)
    }])
)
}

/* *********************************************** */
/* ********** DOCUMENT STARTS HERE *************** */
/* *********************************************** */

/* ********* TOP GRID [CV | NAME | INFO] ************* */
#grid(
  columns: (15%,49%,36%),
  gutter: 4pt,
  /* ********** LEFT CELL (JUST CV)*************** */
  myblock([
  *C V* <cv>
  ],
  radius: (top-left: 15pt),
  under: false,
  height: 40pt
),
  /* ********** CENTRAL CELL [NAME] *************** */
  myblock([
  *#data.at("info").at("name")* <name>
  ],
  under: false,
  height: 40pt
),
  /* ********** RIGHT CELL [INFO] *************** */
  myblock(
      stack(dir: ttb, spacing: 4pt, 
        stack(
          dir: ltr, 
          spacing: 4pt,
          box(height: 1.1em, image("media/phone.svg")),
          box(height: 1.1em, image("media/telegram.svg")),
          box(height: 1.1em, image("media/whatsapp.svg")),
          align(
            left + horizon,
            data.at("info").at("phone")
          )
        ),
        [#emoji.house #data.at("info").at("address")]
      ),
  radius: (top-right: 15pt),
  under: false,
  height: 40pt
)
)

/* ******** MAIN GRID [WORK EXP | SIDEBAR] *********** */
#grid(
  columns: (65%,35%),
  gutter: 3pt,
  /* ******* LEFT SIDE [WORK EXP] ******** */
  myblock([== Work experience], under: true) +
  for i in data.at("workplaces"){
      workitem(i)
  }, 

  /* ******* RIGHT SIDE [SIDEBAR] ******** */

    /* ****** E-Mail / Socials ******** */
  myblock([== E-Mail / Socials], under: true) + 
  myblock(
    stack(
      dir:ttb,
      spacing: 4pt,
      iconlink("email.svg",data.at("info").at("email")),
      iconlink("twitter.svg",data.at("info").at("twitter")),
      iconlink("github.svg",data.at("info").at("github"))
      )
    ) +

    /* ****** Education ******** */
  myblock([== Education] + line(
    length: 100%,
    stroke: 1pt,
    )
  ) + 

  myblock(
    for i in data.at("education"){[
      *#i.at("degree")* \
      _#i.at("from")_ \
      #text(size:12pt, i.at("dates")) \
      \
      ]}
    ) +

    /* ****** Languages ******** */
  myblock([== Languages], under: true) +

  myblock(
    stack(
      dir: ltr,
      spacing: 0pt,
      for i in data.at("languages") [
        *#i.at("cat"):* #h(1fr) #i.at("langs") \
      ] 
)
    ) +

    /* ****** Skills ******** */
  myblock([== Technical skills], under: true) +

  myblock(
    stack(
      dir: ltr,
      spacing: 0pt,
      for i in data.at("skills") [
        *#i.at("name")* #h(1fr)
        #for p in i.at("values") [
          #h(1fr) #p \
        ]
        ] 
)
    ) +

    /* ****** Certificates ******** */
  myblock([== Certificates], under: true) +

  myblock(
    stack(
      dir: ltr,
      spacing: 0pt,
      for i in data.at("certificates") {[
        - _\"#i.at("title")\"_, #i.at("dates")
        ]}
      ),
    radius: (bottom-right: 10pt),
    )
  )
