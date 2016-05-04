MAKEFLAGS += -s

# tools
MKDIR_P=mkdir -p
MKTARGETDIR=$(MKDIR_P) $(@D)
RM = rm -rf
HAML = haml
SASS = sass
COFFEE = coffee

# source
HAML_PATH = src/haml
SASS_PATH = src/sass
COFFEE_PATH = src/coffee

# public
ROOT_PATH = public
IMAGE_PATH = $(ROOT_PATH)/images
JS_PATH = $(ROOT_PATH)/js
CSS_PATH = $(ROOT_PATH)/css

CS = $(wildcard $(COFFEE_PATH)/*.coffee)
LITCOFFEE = $(wildcard $(COFFEE_PATH)/*.litcoffee)

HTML_SRC = $(wildcard $(HAML_PATH)/*.html.haml)
SVG_SRC = $(wildcard $(HAML_PATH)/*.svg.haml)
CSS_SRC = $(wildcard $(SASS_PATH)/*.sass)
JS_SRC = $(COFFEE) $(LITCOFFEE)

SOURCE = $(HTML_SRC) $(SVG_SRC) $(CSS_SRC) $(JS_SRC)

HTML = $(patsubst $(HAML_PATH)/%.html.haml, $(ROOT_PATH)/%.html, $(HTML_SRC))
SVG = $(patsubst $(HAML_PATH)/%.svg.haml, $(IMAGE_PATH)/%.svg, $(SVG_SRC))
CSS = $(patsubst $(SASS_PATH)/%.sass, $(CSS_PATH)/%.css, $(CSS_SRC))

HTML = $(HTML_HAML:.html.haml=.html)
CSS = $(SASS:.sass=.css)

.PHONY: all watch clean

all: $(HTML) $(SVG) $(CSS)
	echo Build done.

watch:
	fswatch -o $(SOURCE) Makefile | xargs -n1 -I{} make

define make-html
$1: $(patsubst $(ROOT_PATH)/%, $(HAML_PATH)/%.haml, $1)
	$(MKDIR_P) $$(@D)
	$(HAML) $$< $$@
endef

define make-svg
$1: $(patsubst $(IMAGE_PATH)/%, $(HAML_PATH)/%.haml, $1)
	$(MKDIR_P) $$(@D)
	$(HAML) $$< $$@
endef

define make-css
$1: $(patsubst $(CSS_PATH)/%.css, $(SASS_PATH)/%.sass, $1)
	$(MKDIR_P) $$(@D)
	$(SASS) $$< $$@
endef

clean:
	$(RM) $(HTML)
	$(RM) $(SVG)
	$(RM) $(CSS)

$(foreach html_file,$(HTML),$(eval $(call make-html,$(html_file))))
$(foreach svg_file,$(SVG),$(eval $(call make-svg,$(svg_file))))
$(foreach css_file,$(CSS),$(eval $(call make-css,$(css_file))))

