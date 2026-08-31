import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["input", "hidden", "list", "option", "group", "empty", "data"]

  connect() {
    this.activeIndex = -1
    this.units = JSON.parse(this.dataTarget.textContent)
    this.close()
  }

  filter() {
    const query = this.inputTarget.value.trim().toLowerCase()
    if (query === "") {
      this.listTarget.replaceChildren()
      this.emptyTarget.hidden = true
      this.close()
      return
    }

    this.renderResults(query)
    this.activeIndex = -1
    if (this.optionTargets.length > 0) this.open()
  }

  navigate(event) {
    if (event.key === "ArrowDown" || event.key === "ArrowUp") {
      event.preventDefault()
      this.moveActive(event.key === "ArrowDown" ? 1 : -1)
    } else if (event.key === "Enter") {
      event.preventDefault()
      this.selectActive()
    } else if (event.key === "Escape") {
      event.preventDefault()
      this.close()
    }
  }

  open() {
    if (this.inputTarget.value.trim() === "") return
    this.listTarget.hidden = false
    this.inputTarget.setAttribute("aria-expanded", "true")
  }

  close() {
    this.listTarget.hidden = true
    this.inputTarget.setAttribute("aria-expanded", "false")
    this.clearActive()
  }

  closeOnOutside(event) {
    if (!this.element.contains(event.target)) this.close()
  }

  clear() {
    this.inputTarget.value = ""
    this.hiddenTarget.value = ""
    this.filter()
    this.inputTarget.focus()
  }

  renderResults(query) {
    const matches = this.units
      .filter((unit) => `${unit.faction} ${unit.name}`.toLowerCase().includes(query))
      .slice(0, 50)
    const groups = new Map()

    matches.forEach((unit) => {
      if (!groups.has(unit.faction)) groups.set(unit.faction, [])
      groups.get(unit.faction).push(unit)
    })

    this.listTarget.replaceChildren()
    groups.forEach((units, faction) => {
      const group = document.createElement("div")
      group.setAttribute("role", "group")
      group.setAttribute("aria-label", faction)
      group.dataset.catalogUnitComboboxTarget = "group"

      const heading = document.createElement("strong")
      heading.textContent = faction
      group.appendChild(heading)

      units.forEach((unit) => {
        const option = document.createElement("div")
        option.id = `catalog-unit-option-${unit.id}`
        option.setAttribute("role", "option")
        option.tabIndex = -1
        option.dataset.catalogUnitComboboxTarget = "option"
        option.dataset.action = "mouseenter->catalog-unit-combobox#activate click->catalog-unit-combobox#select"
        option.dataset.value = unit.id
        option.dataset.label = `${unit.faction} · ${unit.name}`
        option.dataset.searchText = `${unit.faction} ${unit.name}`.toLowerCase()
        option.textContent = option.dataset.label
        group.appendChild(option)
      })

      this.listTarget.appendChild(group)
    })

    this.emptyTarget.hidden = matches.length > 0
    this.listTarget.hidden = matches.length === 0
  }

  activate(event) {
    const option = event.currentTarget
    this.activeIndex = this.visibleOptions.indexOf(option)
    this.updateActive()
  }

  select(event) {
    this.applySelection(event.currentTarget)
  }

  selectActive() {
    const option = this.visibleOptions[this.activeIndex]
    if (option) this.applySelection(option)
  }

  moveActive(step) {
    const options = this.visibleOptions
    if (options.length === 0) return

    this.activeIndex = (this.activeIndex + step + options.length) % options.length
    this.updateActive()
  }

  applySelection(option) {
    this.inputTarget.value = option.dataset.label
    this.hiddenTarget.value = option.dataset.value
    this.close()
  }

  updateActive() {
    this.optionTargets.forEach((option) => {
      option.classList.toggle("is-active", this.visibleOptions[this.activeIndex] === option)
    })

    const activeOption = this.visibleOptions[this.activeIndex]
    this.inputTarget.setAttribute("aria-activedescendant", activeOption?.id || "")
  }

  clearActive() {
    this.optionTargets.forEach((option) => option.classList.remove("is-active"))
    this.inputTarget.setAttribute("aria-activedescendant", "")
  }

  get visibleOptions() {
    return this.optionTargets.filter((option) => !option.hidden)
  }
}
