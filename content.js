/* ============================================================
   공생미생물연구실 — 내용 파일

   이 파일 하나만 고치면 논문 · 소식 · 구성원이 사이트 전체에 반영됩니다.
   HTML 은 건드리지 않아도 됩니다.

   ▸ 규칙 두 가지
     1) 각 줄은 대괄호 [ ] 안에 큰따옴표 " " 로 감싼 항목들이 쉼표로 이어집니다.
     2) 줄 끝의 쉼표를 지우지 마세요. 마지막 줄만 쉼표가 없어도 됩니다.

   ▸ 글자 꾸미기
     <b>굵게</b>      <i>기울임 — 학명에 사용</i>
   ============================================================ */

/* ── 논문 ────────────────────────────────────────────────
   새 논문은 맨 위에 한 줄 추가하고 번호만 올리면 됩니다.
   순서: [번호, 연도, 저자, 제목, 저널]
   저자에서 <b>Oh S-Y</b> 처럼 감싸면 굵게 표시됩니다.        */
const PUBLICATIONS = [
  [
    75,
    2026,
    "Cha Y, You Y-H, Lee S-Y, Jung H-Y, Kim C, <b>Oh S-Y</b>",
    "The complete mitochondrial genome of <i>Fusicolla acetilerea</i> (Nectriaceae, Hypocreales)",
    "Mitochondrial DNA Part B"
  ],
  [
    74,
    2026,
    "<b>Oh S-Y*</b>, Hwang J-A, Jeong HS, Cha Y",
    "Temporal turnover of aquatic fungal communities driven by water quality changes in FLOCponics Japanese eel aquaculture system",
    "Journal of Fungi"
  ],
  [
    73,
    2026,
    "Dalantai M, Lee S-Y, Jung H-Y, You Y-H, Kim C, <b>Oh S-Y</b>",
    "Draft genome sequence of the plastic-degrading fungus <i>Fusicolla acetilerea</i> strain NIBRFGC000505922",
    "BMC Genomic Data 27: 21"
  ],
  [
    72,
    2026,
    "Dalantai M, <b>Oh S-Y</b>",
    "The complete mitochondrial genome sequence of <i>Trichoderma texanum</i> (Hypocreales, Sordariomycetes)",
    "Mitochondrial DNA Part B"
  ],
  [
    71,
    2026,
    "Park KH†, <b>Oh S-Y†</b>, Yoo S, Cho Y, Kim JS, Seo CW, Kim CS, Lim YW",
    "Effects of sequencing platforms on the profiling of root mycorrhizal communities in <i>Pinus densiflora</i>",
    "Journal of Microbiology"
  ],
  [
    70,
    2026,
    "You YH, Kim M, Lee H, Kim C, <b>Oh S-Y</b>",
    "Genome sequences of three Polyporaceae species (Polyporales, Basidiomycota) from South Korea",
    "Mycobiology"
  ],
  [
    69,
    2026,
    "Yang J, Park JS, Oh SO, <b>Oh S-Y</b>, Hur J-S",
    "Fungal microbiome within lichen as a potential bioindicator of climate change: Insights from transplant field study",
    "Mycobiology"
  ],
  [
    68,
    2026,
    "Yang J, Seo J, Choi J, Cha Y, Jang Y, Hwang JA*, <b>Oh S-Y*</b>",
    "Achievement of prosperous nitrification cycle fosters diversity in freshwater microbiome within recirculating aquaculture systems after adjustment period",
    "Aquaculture 742941"
  ],
  [
    67,
    2025,
    "<b>Oh S-Y</b>, Park MS",
    "Fungal diversity associated with the Joro spider <i>Trichonephila clavata</i> in urban parks and mountain forests of Changwon, South Korea",
    "The Korean Journal of Mycology"
  ],
  [
    66,
    2025,
    "Woo J-J, Lücking R, <b>Oh S-Y</b>, Jeun Y-C, Hur J-S",
    "Uncovering hidden lineages in Korean foliicolous lichens (Strigulaceae, Strigulales): Discovery of a new cryptic genus and species",
    "Mycobiology"
  ],
  [
    65,
    2025,
    "Noh Y, Cha Y, <b>Oh S-Y</b>",
    "Comparative analysis of the mycobiomes of two terrestrial isopods, <i>Armadillidium vulgare</i> and <i>Spherillo obscurus</i>",
    "Mycobiology"
  ],
  [
    64,
    2025,
    "<b>Oh S-Y</b>, Jang Y",
    "New <i>Trichoderma</i> species and six unrecorded species of endolichenic fungi isolated from lichens",
    "Mycobiology"
  ],
  [
    63,
    2025,
    "<b>Oh S-Y</b>, Woo J-J, Hur J-S",
    "Distribution and genetic diversity of the Korean foliicolous lichen, <i>Strigula depressa</i>",
    "Mycobiology"
  ],
  [
    62,
    2025,
    "Yang J, Cha Y, <b>Oh S-Y</b>",
    "Habitat prevails over host sex in influencing mycobiome structure of terrestrial isopod, <i>Armadillidium vulgare</i>",
    "Microbiology Spectrum 13(5): e02172-24"
  ],
  [
    61,
    2025,
    "Yang J, Choi H, Park JS, Cha Y, Hwang J-A, <b>Oh S-Y</b>",
    "Biofloc technology significantly reshapes water microbiome and improves survival rates in Japanese eel (<i>Anguilla japonica</i>)",
    "Microbiology Spectrum"
  ],
  [
    60,
    2024,
    "<b>Oh S-Y</b>, Jang Y",
    "First report of <i>Metarhizium viridulum</i> isolated from the cicada (<i>Cryptotympana atrata</i>) in South Korea",
    "The Korean Journal of Mycology"
  ],
  [
    59,
    2024,
    "<b>Oh S-Y</b>, Cha Y",
    "Influence of host sex on mycobiome structure in <i>Porcellio laevis</i> using metabarcoding analysis",
    "The Korean Journal of Mycology"
  ],
  [
    58,
    2024,
    "<b>Oh S-Y</b>",
    "Archaeal diversity in fairy ring soil of <i>Tricholoma matsutake</i> using a metabarcoding analysis",
    "Journal of Mushrooms"
  ],
  [
    57,
    2024,
    "Choi H, Park JS, Hwang J-A, Kim S-K, Cha Y, <b>Oh S-Y</b>",
    "Influence of biofloc technology and continuous flow systems on aquatic microbiota and water quality in Japanese eel aquaculture",
    "Diversity"
  ],
  [
    56,
    2024,
    "<b>Oh S-Y</b>",
    "The complete mitochondrial genome of <i>Clonostachys farinosa</i> (Bionectriaceae, Hypocreales)",
    "Mitochondrial DNA Part B"
  ],
  [
    55,
    2024,
    "Kherlenchimeg N, Burenbaatar G, Baasanmunkh S, Tsegmed Z, Urgamal M, Bau T, Han S-K, <b>Oh S-Y*</b>, Choi HJ*",
    "Improved understanding of the macrofungal diversity of Mongolia: Species richness, conservation status, and an annotated checklist",
    "Mycobiology"
  ],
  [
    54,
    2024,
    "Jang JE, Baasanmunkh S, Nyamgerel N, <b>Oh S-Y</b>, Song JH, Yusupov Z, Tojibaev K, Choi HJ",
    "Flower morphology of <i>Allium</i> (Amaryllidaceae) and its systematic significance",
    "Plant Diversity"
  ],
  [
    53,
    2023,
    "Yang J, Woo JJ, Kim W, <b>Oh S-Y</b>, Hur JS",
    "Exploring the influence of climatic variables on mycobiome composition and community diversity in lichens: insights from structural equation modeling analysis",
    "Environmental Microbiome"
  ],
  [
    52,
    2023,
    "Yang J, Woo JJ, <b>Oh S-Y</b>, Kim W, Hur JS",
    "Fungal community inside lichen: a curious case of sparse diversity and high modularity",
    "Environmental Microbiome"
  ],
  [
    51,
    2023,
    "Hwang J-A, Park JS, Jeong HS, Kim H, <b>Oh S-Y</b>",
    "Productivity of fish and crop growth and characteristics of bacterial communities in the FLOCponics system",
    "Fishes"
  ],
  [
    50,
    2023,
    "Park KH†, <b>Oh S-Y†</b>, Cho Y, Seo CW, Kim JS, Yoo S, Lim J, Kim CS, Lim YW",
    "Mycorrhizal fungal diversity associated with six understudied ectomycorrhizal trees in the Republic of Korea",
    "Journal of Microbiology 61(8): 729-739"
  ],
  [
    49,
    2023,
    "Cha Y, <b>Oh S-Y</b>",
    "Fungal diversity associated with <i>Armadillidium</i> isopods: A case study in Central Park of Gwacheon, South Korea",
    "Diversity 15(4): 533"
  ],
  [
    48,
    2022,
    "<b>Oh S-Y</b>",
    "Unrecorded mycoparasitic fungus <i>Sepedonium laevigatum</i> isolated from wild mushrooms in South Korea",
    "Journal of Mushrooms 20(4): 249-253"
  ],
  [
    47,
    2022,
    "Son H, <b>Oh S-Y</b>, Lee K",
    "Genome sequences of the human-skin-originated <i>Brevundimonas albigilva</i> TT17 and the soil-originated <i>B. albigilva</i> KEME 9005-016T",
    "Microbiology Resource Announcements e00776-22"
  ],
  [
    46,
    2022,
    "Yang JH, <b>Oh S-Y</b>, Kim W, Hur J-S",
    "Endolichenic fungal community analysis by pure culture isolation and metabarcoding: A case study of <i>Parmotrema tinctorum</i>",
    "Mycobiology 50(1): 55-65"
  ],
  [
    45,
    2021,
    "Heo YM, <b>Oh S-Y</b>, Kim K, Han S-I, Kwon SL, Yoo Y, Kim D, Khim JS, Kang S, Lee H, Kim J-J",
    "Comparative genomics and transcriptomics depict marine algicolous <i>Arthrinium</i> species as endosymbionts that help regulate oxidative stress in brown algae",
    "Frontiers in Marine Science 8: 753222"
  ],
  [
    44,
    2021,
    "Kim W, Liu R, Woo S, Kang KB, Park H, Yu YH, Ha H-H, <b>Oh S-Y</b>, Yang JH, Kim H, Yun S-H, Hur J-S",
    "Linking a gene cluster to atranorin, a major cortical substance of lichens, through genetic dereplication and heterologous expression",
    "mBio 12: e01111-21"
  ],
  [
    43,
    2021,
    "Yang JH, <b>Oh S-Y</b>, Kim W, Woo J-J, Kim H, Hur J-S",
    "Effect of isolation conditions on diversity of endolichenic fungal communities from a foliose lichen, <i>Parmotrema tinctorum</i>",
    "Journal of Fungi 7: 335"
  ],
  [
    42,
    2021,
    "<b>Oh S-Y</b>, Park KH, Baldrian P, Fong JJ, Kwon HJ, Kim S-Y, Lim YW",
    "Fungal diversity living in the root and sporophore of the endemic Korean fern <i>Mankyua chejuense</i>",
    "Fungal Ecology 50: 101038"
  ],
  [
    41,
    2020,
    "Park KH†, <b>Oh S-Y†</b>, Yoo S, Park MS, Fong JJ, Kim CS, Jo JW, Lim YW",
    "Influence of season and soil properties on fungal communities of neighboring climax forests (<i>Carpinus cordata</i> and <i>Fraxinus rhynchophylla</i>)",
    "Frontiers in Microbiology 11: 572706"
  ],
  [
    40,
    2020,
    "Park KH†, <b>Oh S-Y†</b>, Yoo S, Park MS, Fong JJ, Lim YW",
    "Successional change of the fungal microbiome pine seedling roots inoculated with <i>Tricholoma matsutake</i>",
    "Frontiers in Microbiology 11: 574146"
  ],
  [
    39,
    2020,
    "Noh P, <b>Oh S-Y</b>, Park S, Kwon T, Kim Y, Choe JC, Jeong G",
    "Association between host wing morphology polymorphism and <i>Wolbachia</i> infection in <i>Vollenhovia emeryi</i>",
    "Ecology and Evolution 10(16): 8827-8837"
  ],
  [
    38,
    2020,
    "Lee H, <b>Oh S-Y</b>, Lee YM, Jang Y, Jang S, Kim C, Lim YW, Kim J-J",
    "Successional variation in the soil microbial community in Odaesan National Park, Korea",
    "Sustainability 12(11): 4795"
  ],
  [
    37,
    2020,
    "Kim H, Lee C-R, Lee S-K, <b>Oh S-Y</b>, Kim W",
    "Biodiversity and community structure of mesozooplankton in the marine and coastal national park areas of Korea",
    "Diversity 12(6): 233"
  ],
  [
    36,
    2020,
    "Woo J-J, Lücking R, <b>Oh S-Y</b>, Jeun Y-C, Hur J-S",
    "Two new foliicolous species of <i>Strigula</i> (Strigulaceae, Strigulales) in Korea offer insight in phorophyte-dependent variation of thallus morphology",
    "Phytotaxa 443(1): 1-12"
  ],
  [
    35,
    2020,
    "<b>Oh S-Y</b>, Yang JH, Woo J-J, Oh S-O, Hur J-S",
    "Diversity and distribution patterns of endolichenic fungi in Jeju Island, South Korea",
    "Sustainability 12(9): 3769"
  ],
  [
    34,
    2020,
    "Park J-H, Pavlov IN, Kim M-J, Park MS, <b>Oh S-Y</b>, Park KH, Fong JJ, Lim YW",
    "Investigating wood decaying fungi diversity in Central Siberia, Russia using ITS sequence analysis and interaction with host trees",
    "Sustainability 12(6): 2535"
  ],
  [
    33,
    2019,
    "Groffen J, <b>Oh S-Y</b>, Kwon S, Jang Y, Borzée A",
    "High mortality in <i>Bufo gargarizans</i> eggs associated with an undescribed <i>Saprolegnia ferax</i> strain in the Republic of Korea",
    "Diseases of Aquatic Organisms 137(2): 89-99"
  ],
  [
    32,
    2019,
    "Lupala AS, <b>Oh S-Y</b>, Park MS, Kim T, Yoo J-S, Seelan JSS, Lim YW",
    "Co-occurrence patterns of wood-decaying fungi and ants in dead pines of South Korea",
    "Journal of Asia-Pacific Entomology 22(4): 1154-1160"
  ],
  [
    31,
    2019,
    "<b>Oh S-Y</b>, Woo J-J, Hur J-S",
    "Distribution of foliicolous lichen <i>Strigula</i> and genetic structure of <i>S. multiformis</i> on Jeju Island, South Korea",
    "Microorganisms 7(10): 430"
  ],
  [
    30,
    2019,
    "Park MS, <b>Oh S-Y</b>, Fong JJ, Houbraken J, Lim YW",
    "The diversity and ecological roles of <i>Penicillium</i> in intertidal zones",
    "Scientific Reports 9: 13540"
  ],
  [
    29,
    2019,
    "<b>Oh S-Y</b>, Park MS, Lim YW",
    "The influence of microfungi on the mycelial growth of ectomycorrhizal fungus <i>Tricholoma matsutake</i>",
    "Microorganisms 7(6): 169"
  ],
  [
    28,
    2019,
    "Phookamsak R, Hyde KD, Jeewon R, … <b>Oh S-Y</b>, et al. (104 authors)",
    "Fungal diversity notes 929-1035: taxonomic and phylogenetic contributions on genera and species of fungi",
    "Fungal Diversity 95(1): 1-273"
  ],
  [
    27,
    2019,
    "Park MS, Jung YH, <b>Oh S-Y</b>, Kim MJ, Bang WY, Lim YW",
    "Cellulosic nanomaterial production via fermentation by <i>Komagataeibacter</i> sp. SFCB22-18 isolated from ripened persimmons",
    "Journal of Microbiology and Biotechnology 29(4): 617-624"
  ],
  [
    26,
    2018,
    "Park KH, <b>Oh S-Y</b>, Park MS, Kim M-S, Klopfenstein NB, Kim NK, Park JY, Kim J-J, Han S-K, Lee JK, Lim YW",
    "Re-evaluation of <i>Armillaria</i> and <i>Desarmillaria</i> in South Korea based on ITS/tef1 sequences and morphological characteristics",
    "Forest Pathology 48(6): e12447"
  ],
  [
    25,
    2018,
    "<b>Oh S-Y</b>, Park MS, Cho HJ, Lim YW",
    "Diversity and effect of <i>Trichoderma</i> isolated from the roots of <i>Pinus densiflora</i> within the fairy ring of pine mushroom (<i>Tricholoma matsutake</i>)",
    "PLoS ONE"
  ],
  [
    24,
    2018,
    "Cho HJ, Park MS, Lee H, <b>Oh S-Y</b>, Wilson AW, Mueller GM, Lim YW",
    "A systematic revision of the ectomycorrhizal genus <i>Laccaria</i> from Korea",
    "Mycologia"
  ],
  [
    23,
    2018,
    "<b>Oh S-Y</b>, Lim YW",
    "Effect of fairy ring bacteria on the growth of <i>Tricholoma matsutake</i> in vitro culture",
    "Mycorrhiza"
  ],
  [
    22,
    2018,
    "<b>Oh S-Y</b>, Lim YW",
    "Root-associated bacteria influencing mycelial growth of <i>Tricholoma matsutake</i> (pine mushroom)",
    "Journal of Microbiology"
  ],
  [
    21,
    2018,
    "Park MS, <b>Oh S-Y</b>, Lee S, Eimes JA, Lim YW",
    "Fungal diversity and enzyme activity associated with sailfin sandfish egg masses in Korea",
    "Fungal Ecology"
  ],
  [
    20,
    2018,
    "<b>Oh S-Y</b>, Cho HJ, Eimes JA, Han S-L, Kim CS, Lim YW",
    "Guild patterns of basidiomycetes community associated with <i>Quercus mongolica</i> in Mt. Jeombong, Republic of Korea",
    "Mycobiology"
  ],
  [
    19,
    2018,
    "<b>Oh S-Y</b>, Kim M, Eimes JA, Lim YW",
    "Effect of fruiting body bacteria on the growth of <i>Tricholoma matsutake</i> and its related molds",
    "PLoS ONE"
  ],
  [
    18,
    2018,
    "Park MS, Eimes JA, Oh SH, Seo HJ, <b>Oh S-Y</b>, Lee S, Park KH, Kwon HJ, Kim S-Y, Lim YW",
    "Diversity of fungi associated with roots of <i>Calanthe</i> orchid species in Korea",
    "Journal of Microbiology"
  ],
  [
    17,
    2018,
    "Nilsson RH, Taylor AFS, Adams RI, … <b>Oh S-Y</b>, … Kõljalg U, Abarenkov K",
    "Taxonomic annotation of public fungal ITS sequences from the built environment",
    "MycoKeys"
  ],
  [
    16,
    2017,
    "Jargalmaa S, Eimes JA, Park MS, Park JY, <b>Oh S-Y</b>, Lim YW",
    "Taxonomic evaluation of selected <i>Ganoderma</i> species and database sequence validation",
    "PeerJ"
  ],
  [
    15,
    2016,
    "<b>Oh S-Y</b>, Fong JJ, Park MS, Lim YW",
    "Distinctive feature of microbial communities and bacterial functional profiles in <i>Tricholoma matsutake</i> dominant soil",
    "PLoS ONE"
  ],
  [
    14,
    2016,
    "Park MS, Lee S, <b>Oh S-Y</b>, Cho GY, Lim YW",
    "Diversity and enzyme activity of <i>Penicillium</i> species associated with macroalgae in Jeju Island",
    "Journal of Microbiology"
  ],
  [
    13,
    2015,
    "Cho HJ, Park MS, Lee H, <b>Oh S-Y</b>, Jang Y, Fong JJ, Lim YW",
    "Four new species of <i>Amanita</i> in Inje County, Korea",
    "Mycobiology"
  ],
  [
    12,
    2015,
    "Lee H, Park MS, Jung PE, Fong JJ, <b>Oh S-Y</b>, Verbeken A, Lim YW",
    "<i>Lactarius cucurbitoides</i> (Russulales, Basidiomycota), a new species from South Korea supported by molecular and morphological data",
    "Phytotaxa"
  ],
  [
    11,
    2015,
    "Park MS, Fong JJ, <b>Oh S-Y</b>, Houbraken J, Sohn JH, Hong SB, Lim YW",
    "<i>Penicillium jejuense</i> sp. nov., isolated from the marine environments of Jeju Island, Korea",
    "Mycologia"
  ],
  [
    10,
    2014,
    "Jung PE, Fong JJ, Park MS, <b>Oh S-Y</b>, Kim C, Lim YW",
    "Sequence validation for the identification of the white-rot fungi <i>Bjerkandera</i> in public sequence databases",
    "Journal of Microbiology and Biotechnology"
  ],
  [
    9,
    2014,
    "Park MS, <b>Oh S-Y</b>, Cho HJ, Fong JJ, Cheon WJ, Lim YW",
    "<i>Trichoderma songyi</i> sp. nov., a new species associated with the pine mushroom (<i>Tricholoma matsutake</i>)",
    "Antonie van Leeuwenhoek"
  ],
  [
    8,
    2014,
    "Park MS, Lee H, <b>Oh S-Y</b>, Jung PE, Seok SJ, Fong JJ, Lim YW",
    "Species delimitation of three species within the <i>Russula</i> subgenus <i>Compacta</i> in Korea: <i>R. eccentrica</i>, <i>R. nigricans</i>, and <i>R. subnigricans</i>",
    "Journal of Microbiology"
  ],
  [
    7,
    2014,
    "Park MS, Fong JJ, <b>Oh S-Y</b>, Kwon KK, Sohn JH, Lim YW",
    "Marine-derived <i>Penicillium</i> in Korea: diversity, enzyme activity, and antifungal properties",
    "Antonie van Leeuwenhoek"
  ],
  [
    6,
    2014,
    "Park MS, Quan Y, Jung PE, <b>Oh S-Y</b>, Jang Y, Kim JJ, Lim YW",
    "Re-evaluation of the genus <i>Antrodia</i> (Polyporales, Basidiomycota) in Korea",
    "Mycobiology"
  ],
  [
    5,
    2014,
    "Lee WD, Lee H, Fong JJ, <b>Oh S-Y</b>, Park MS, Quan Y, Jung PE, Lim YW",
    "A checklist of the basidiomycetous macrofungi and a record of five new species from Mt. Oseo in Korea",
    "Mycobiology"
  ],
  [
    4,
    2014,
    "<b>Oh S-Y</b>, Fong JJ, Park MS, Chang L, Lim YW",
    "Identifying airborne fungi in Seoul, Korea using metagenomics",
    "Journal of Microbiology"
  ],
  [
    3,
    2014,
    "Kim TE, <b>Oh S-Y</b>, Chang E, Jang Y",
    "Host availability hypothesis: complex interactions with abiotic factors and predators may best explain population densities of cicada species",
    "Animal Cells and Systems"
  ],
  [
    2,
    2013,
    "Park MS, Fong JJ, Lee H, <b>Oh S-Y</b>, Jung PE, Min YJ, Seok SJ, Lim YW",
    "Delimitation of <i>Russula</i> subgenus <i>Amoenula</i> in Korea using three molecular markers",
    "Mycobiology"
  ],
  [
    1,
    2012,
    "Lee HY, <b>Oh S-Y</b>, Jang Y",
    "Morphometrics of the final instar exuviae of five cicada species occurring in urban areas of central Korea",
    "Journal of Asia-Pacific Entomology"
  ]
];

/* ── 소식 ────────────────────────────────────────────────
   순서: [날짜, 제목, 설명]
   날짜는 "2026.07.14" 형식. 날짜를 모르면 "2026.00.00" 으로 두세요.
   맨 위 4개가 홈 화면에 자동으로 표시됩니다.                 */
const NEWS = [
  [
    "2026.00.00",
    "Journal of Fungi 논문 게재",
    "FLOCponics 뱀장어 양식 시스템에서 수질 변화에 따른 진균 군집의 교체"
  ],
  [
    "2026.00.00",
    "Aquaculture 논문 게재",
    "순환여과양식시스템의 질산화 정착과 담수 미생물 다양성"
  ],
  [
    "2026.00.00",
    "Journal of Microbiology 논문 게재",
    "시퀀싱 플랫폼에 따른 소나무 뿌리 균근 군집 분석 결과의 차이"
  ],
  [
    "2026.00.00",
    "Mycobiology 논문 게재",
    "국내 Polyporaceae 3종의 유전체 해독"
  ],
  [
    "2026.00.00",
    "BMC Genomic Data 논문 게재",
    "플라스틱 분해 진균 Fusicolla acetilerea의 유전체 초안"
  ],
  [
    "2025.00.00",
    "Microbiology Spectrum 논문 게재",
    "서식지가 숙주 성별보다 육상 등각류 마이코바이옴에 크게 작용한다"
  ],
  [
    "2025.00.00",
    "Microbiology Spectrum 논문 게재",
    "바이오플락 기술이 뱀장어 양식수 미생물 군집과 생존율에 미치는 영향"
  ],
  [
    "2025.00.00",
    "Mycobiology 논문 게재",
    "지의류에서 분리한 내생지의류균 신종 Trichoderma 및 국내 미기록 6종"
  ],
  [
    "2025.00.00",
    "Korean Journal of Mycology 논문 게재",
    "무당거미에 연관된 진균 다양성"
  ]
];

/* ── 현재 구성원 ─────────────────────────────────────────
   순서: [이름, 영문이름, 직위, 비고]
   비고가 없으면 "" 로 비워 두세요.
   여기 적힌 순서 그대로 사이트에 표시됩니다.                 */
const MEMBERS = [
  [
    "차예현",
    "Yehyeon Cha",
    "박사과정",
    ""
  ],
  [
    "달란타이 문크게렐",
    "Munkhgerel Dalantai",
    "박사과정",
    ""
  ],
  [
    "노윤주",
    "Yoonjoo Noh",
    "박사과정",
    ""
  ],
  [
    "우정재",
    "Jung-Jae Woo",
    "박사후연구원",
    "Life Aging Center 공동연구"
  ],
  [
    "서창완",
    "Chang Wan Seo",
    "박사후연구원",
    "G-LAMP 공동연구"
  ],
  [
    "변하연",
    "Hayeon Byun",
    "전임연구원",
    ""
  ],
  [
    "조수민",
    "Sumin Jo",
    "전임연구원",
    ""
  ]
];

/* ── 함께했던 사람들 ─────────────────────────────────────
   순서: [이름, 영문이름, 당시 직위, 현재 소속]              */
const ALUMNI = [
  [
    "박기형",
    "Ki Hyeong Park",
    "박사후연구원",
    "국립산림과학원"
  ],
  [
    "양지호",
    "Jiho Yang",
    "박사후연구원",
    "University of Hawaii"
  ],
  [
    "오아미",
    "Ami Oh",
    "박사후연구원",
    "국립수목원"
  ],
  [
    "최현준",
    "Hyunjun Choi",
    "석사 졸업",
    "연구원"
  ],
  [
    "장윤혁",
    "Yunhyeok Jang",
    "석사 졸업",
    "연구원"
  ]
];

/* ── 어느 논문을 어디에 보여줄지 ────────────────────────
   위 PUBLICATIONS 목록의 '번호'만 적으면 됩니다.
   적은 순서대로 화면에 표시됩니다.                          */

/* 홈 화면에 보이는 논문 (3편 정도가 적당합니다) */
const HOME_PUBS = [73, 68, 62];

/* 논문 페이지 맨 위의 '대표 논문' (5편) */
const FEATURED = [73, 68, 62, 42, 23];

/* 연구 하위 페이지별 '대표 논문' */
const PAGE_PUBS = {
  "lichen":    [64, 63, 35, 31],
  "matsutake": [23, 22, 19, 29, 25, 15, 58, 40],
  "diversity": [71, 50, 41, 20, 42, 55, 72, 70],
  "animals":   [62, 65, 59, 49, 67, 60, 61, 68, 74]
};
