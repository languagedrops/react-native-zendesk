import { NativeModules } from 'react-native'

const { RNZendesk } = NativeModules

interface Config {
  appId: string
  clientId: string
  zendeskUrl: string
}

// MARK: - Initialization

export function initialize(config: Config) {
  RNZendesk.initialize(config)
}

// MARK: - Indentification

export function identifyJWT(token: string) {
  RNZendesk.identifyJWT(token)
}

export function identifyAnonymous(name?: string, email?: string) {
  RNZendesk.identifyAnonymous(name, email)
}

// MARK: - UI Methods

interface CustomField {
  id: number
  value: number | string | boolean
}

interface HelpCenterOptions {
  hideContactSupport?: boolean
  fields?: CustomField[]
}

export function showHelpCenter(options: HelpCenterOptions) {
  RNZendesk.showHelpCenter(options)
}

interface NewTicketOptions {
  tags?: string[]
  fields?: CustomField[]
}

export function showNewTicket(options: NewTicketOptions) {
  RNZendesk.showNewTicket(options)
}

export function showTickets(options: NewTicketOptions) {
  RNZendesk.showNewTicket(options)
}
