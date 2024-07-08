//
//  Supabase.swift
//  pressboxd
//
//  Created by Jackson Moody on 6/22/24.
//

import Foundation
import Supabase

let supabase = SupabaseClient(
  supabaseURL: URL(string: "https://dxaijmqvdprjuehhjtzb.supabase.co")!,
  supabaseKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImR4YWlqbXF2ZHByanVlaGhqdHpiIiwicm9sZSI6ImFub24iLCJpYXQiOjE3MTkwODM4MDgsImV4cCI6MjAzNDY1OTgwOH0.HkoXO2-uAD4PwM214eTUClu4mTyTU6WCdCHHpG3PdCA"
)
